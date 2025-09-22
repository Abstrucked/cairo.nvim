local M = {}

function M.setup()
	local lspconfig = require("lspconfig")
	local configs = require("lspconfig.configs")
	local util = require("lspconfig.util")

	local get_cairo_ls_cmd = function()
		local scarb = vim.fn.exepath("scarb")
		local cairo_ls = vim.fn.exepath("cairo-language-server")

		if scarb ~= "" then
			return { scarb, "cairo-language-server" }
		elseif cairo_ls ~= "" then
			return { cairo_ls }
		else
			return { "scarb", "cairo-language-server" }
		end
	end

	local function setup_cairo_ls()
		local cmd = get_cairo_ls_cmd()

		if not configs.cairo_ls then
			configs.cairo_ls = {
				default_config = {
					cmd = cmd,
					filetypes = { "cairo" },
					root_dir = function(fname)
						return util.root_pattern("Scarb.toml", "cairo_project.toml", ".git")(fname)
							or vim.fs.dirname(fname)
					end,
					single_file_support = true,
					settings = {},
				},
			}
		else
			configs.cairo_ls.default_config.cmd = cmd
		end

		lspconfig.cairo_ls.setup({})
	end

	-- Setup the LSP configuration
	setup_cairo_ls()

	-- Health check function
	vim.api.nvim_create_user_command("CheckCairoLSP", function()
		local cmd = get_cairo_ls_cmd()
		local executable = vim.fn.executable(cmd[1])
		local message = executable == 1 and ("Cairo LSP command '%s' is available"):format(cmd[1])
			or ("Cairo LSP command '%s' is not available"):format(cmd[1])

		vim.notify("Cairo LSP: " .. message, executable == 1 and vim.log.levels.INFO or vim.log.levels.WARN)
	end, { desc = "Check if Cairo LSP command is available" })
end

return M
