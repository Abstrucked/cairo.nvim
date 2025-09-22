local M = {}

function M.setup_formatters(opts)
	opts.formatters_by_ft = opts.formatters_by_ft or {}
	opts.formatters = opts.formatters or {}

	local scarb = vim.fn.exepath("scarb")
	if scarb ~= "" then
		-- Remove any existing cairo formatters to avoid conflicts
		if opts.formatters_by_ft.cairo then
			opts.formatters_by_ft.cairo = nil
		end

		-- Define the scarb formatter
		opts.formatters["cairo-scarb-fmt"] = {
			command = scarb,
			args = { "fmt", "$FILENAME" },
			stdin = false,
			cwd = function()
				return require("conform.util").root_file({ "Scarb.toml", "cairo_project.toml", ".git" })
			end,
			exit_on_error = true,
		}

		-- Set cairo filetype to use scarb formatter
		opts.formatters_by_ft.cairo = { "cairo-scarb-fmt" }
	end

	-- Add health check for formatting
	local group = vim.api.nvim_create_augroup("cairo_format_health", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "cairo",
		callback = function()
			vim.schedule(function()
				if scarb ~= "" then
					vim.notify("Cairo formatting with scarb is available", vim.log.levels.INFO)
				else
					vim.notify("scarb not found - Cairo formatting disabled", vim.log.levels.WARN)
				end
			end)
		end,
	})
end

return M
