local M = {}

-- Cache the LSP command to avoid repeated exepath calls
local _cairo_ls_cmd = nil

local function get_cairo_ls_cmd()
	if _cairo_ls_cmd then
		return _cairo_ls_cmd
	end

	local scarb = vim.fn.exepath("scarb")
	local cairo_ls = vim.fn.exepath("cairo-language-server")

	if scarb ~= "" then
		_cairo_ls_cmd = { scarb, "cairo-language-server" }
	elseif cairo_ls ~= "" then
		_cairo_ls_cmd = { cairo_ls }
	else
		_cairo_ls_cmd = nil
	end

	return _cairo_ls_cmd
end

local function lsp_status()
	local cmd = get_cairo_ls_cmd()
	if not cmd then
		return "❌ Not found (install scarb or cairo-language-server)"
	end

	local executable = vim.fn.executable(cmd[1])
	local clients = vim.lsp.get_clients({ name = "cairo_ls" })

	if executable == 1 and #clients > 0 then
		return string.format("✅ Active (%d buffer%s)", #clients, #clients == 1 and "" or "s")
	elseif executable == 1 then
		return "⚠️  Ready (not attached)"
	else
		return "❌ Not executable"
	end
end

function M.setup(config)
	M.config = config
	local lspconfig = require("lspconfig")
	local configs = require("lspconfig.configs")
	local util = require("lspconfig.util")

	local cmd = get_cairo_ls_cmd()
	if not cmd then
		vim.notify(
			"Cairo LSP: Neither scarb nor cairo-language-server found in PATH.\n"
				.. "Install with: cargo install --git https://github.com/xJonathanLEI/cairo-language-server",
			vim.log.levels.WARN
		)
		return
	end

	local lsp_config = {
		cmd = cmd,
		filetypes = { "cairo" },
		root_dir = function(fname)
			return util.root_pattern(unpack(config.root_markers))(fname) or vim.fn.fnamemodify(fname, ":p:h")
		end,
		single_file_support = true,
		settings = {
			cairo = config.settings.cairo,
		},
	}

	-- Register the server configuration
	if not configs.cairo_ls then
		configs.cairo_ls = {
			default_config = lsp_config,
		}
	else
		-- Update existing config
		configs.cairo_ls.default_config = vim.tbl_extend("force", configs.cairo_ls.default_config or {}, lsp_config)
	end

	-- Setup the server
	lspconfig.cairo_ls.setup({
		on_attach = function(client, bufnr)
			-- Minimal on_attach - no keymaps
			local msg = string.format("Cairo LSP attached to %s", vim.api.nvim_buf_get_name(0))
			vim.notify(msg, vim.log.levels.INFO)

			-- Notify about capabilities
			local caps = {}
			if client.server_capabilities.completionProvider then
				table.insert(caps, "completion")
			end
			if client.server_capabilities.documentFormattingProvider then
				table.insert(caps, "formatting")
			end
			if client.server_capabilities.definitionProvider then
				table.insert(caps, "navigation")
			end

			if #caps > 0 then
				vim.notify("Cairo LSP capabilities: " .. table.concat(caps, ", "), vim.log.levels.INFO)
			end

			-- Cairo-specific buffer commands
			M.setup_buffer_commands(bufnr)
		end,

		on_init = function(client)
			-- Log initialization
			client.config.cmd = cmd -- Ensure the command is set
			vim.notify("Cairo LSP initializing with: " .. vim.inspect(cmd), vim.log.levels.DEBUG)
			return true
		end,

		capabilities = vim.lsp.protocol.make_client_capabilities(),
	})
end

function M.setup_buffer_commands(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	-- Cairo-specific commands for the buffer
	vim.api.nvim_buf_create_user_command(bufnr, "CairoCheck", function()
		M.check_lsp_detailed()
	end, {
		desc = "Check Cairo LSP status and diagnostics",
		force = true,
	})

	vim.api.nvim_buf_create_user_command(bufnr, "CairoRestart", function()
		local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "cairo_ls" })
		for _, client in ipairs(clients) do
			client.stop(client)
		end
		require("lspconfig").cairo_ls.setup({})
		vim.notify("Cairo LSP restarted", vim.log.levels.INFO)
	end, {
		desc = "Restart Cairo LSP for current buffer",
		force = true,
	})

	-- Project commands
	vim.api.nvim_buf_create_user_command(bufnr, "CairoLocateProject", function()
		local root = require("lspconfig.util").root_pattern(unpack(M.config.root_markers))(vim.fn.expand("%:p"))
		if root then
			vim.notify("Cairo project root: " .. root, vim.log.levels.INFO)
			vim.cmd("edit " .. root)
		else
			vim.notify("No Cairo project root found", vim.log.levels.WARN)
		end
	end, {
		desc = "Locate and open Cairo project root",
		force = true,
	})
end

function M.setup_diagnostics(config)
	local diagnostics = config or {}

	-- Configure diagnostics globally for Cairo files
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "cairo",
		callback = function()
			vim.diagnostic.config({
				virtual_text = diagnostics.virtual_text ~= false,
				underline = diagnostics.underline ~= false,
				update_in_insert = diagnostics.update_in_insert or false,
				severity_sort = diagnostics.severity_sort or true,
				float = {
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			}) -- Global diagnostic config for Cairo files
		end,
	})
end

function M.check_lsp()
	vim.notify("Cairo LSP Status: " .. lsp_status(), vim.log.levels.INFO)
end

function M.check_lsp_detailed()
	local cmd = get_cairo_ls_cmd()
	vim.notify("=== Cairo LSP Detailed Status ===", vim.log.levels.INFO)

	if not cmd then
		vim.notify("❌ Language server not found", vim.log.levels.ERROR)
		vim.notify(
			"Install scarb: curl -sSf https://raw.githubusercontent.com/modelchecking/scarb/main/install.sh | bash",
			vim.log.levels.INFO
		)
		return
	end

	vim.notify("Command: " .. table.concat(cmd, " "), vim.log.levels.INFO)
	vim.notify(
		"Executable: " .. (vim.fn.executable(cmd[1]) == 1 and "✅" or "❌"),
		vim.fn.executable(cmd[1]) == 1 and vim.log.levels.INFO or vim.log.levels.WARN
	)

	local clients = vim.lsp.get_clients({ name = "cairo_ls" })
	vim.notify(string.format("Active clients: %d", #clients), vim.log.levels.INFO)

	if #clients > 0 then
		for i, client in ipairs(clients) do
			local root = client.config.root_dir and client.config.root_dir(vim.fn.expand("%:p"))
			vim.notify(string.format("Client %d - Root: %s", i, root or "N/A"), vim.log.levels.INFO)
		end
	end

	-- Current buffer diagnostics
	local bufnr = vim.api.nvim_get_current_buf()
	local diagnostics = vim.diagnostic.get(bufnr)
	local severity_counts = {}
	for _, diag in ipairs(diagnostics) do
		local sev = vim.diagnostic.severity[diag.severity]
		severity_counts[sev] = (severity_counts[sev] or 0) + 1
	end

	if next(severity_counts) then
		local diag_str = {}
		for severity, count in pairs(severity_counts) do
			table.insert(diag_str, string.format("%s: %d", severity, count))
		end
		vim.notify("Diagnostics: " .. table.concat(diag_str, ", "), vim.log.levels.INFO)
	else
		vim.notify("No diagnostics in current buffer", vim.log.levels.INFO)
	end
end

-- Public API for integration with other plugins
M.clients = function()
	return vim.lsp.get_clients({ name = "cairo_ls" })
end

M.is_attached = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "cairo_ls" })
	return #clients > 0
end

return M
