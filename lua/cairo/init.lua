local M = {}

-- Default configuration
local defaults = {
	enabled = true,
	root_markers = { "Scarb.toml", "cairo_project.toml", ".git" },
	settings = {
		-- Cairo-specific LSP settings
		cairo = {
			-- Add any Cairo-specific settings here
		},
	},
	diagnostics = {
		virtual_text = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	},
}

M.config = vim.deepcopy(defaults)

function M.setup(opts)
	if not opts.enabled and opts.enabled ~= nil then
		vim.notify("Cairo.nvim disabled", vim.log.levels.INFO)
		return
	end

	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	-- Check dependencies
	local status_ok, lspconfig = pcall(require, "lspconfig")
	if not status_ok then
		vim.notify("Cairo.nvim: nvim-lspconfig not found", vim.log.levels.WARN)
		return
	end

	-- Setup LSP
	require("cairo.lsp").setup(M.config)

	-- Setup diagnostics config
	require("cairo.lsp").setup_diagnostics(M.config.diagnostics)

	vim.notify("Cairo.nvim LSP configured", vim.log.levels.INFO)
end

-- Lazy.nvim plugin specification
M.spec = {
	"Abstrucked/cairo.nvim",
	event = { "BufReadPre *.cairo", "BufNewFile *.cairo" },
	ft = "cairo",
	dependencies = {
		{
			"amanusk/cairo-1-vim-config",
			name = "cairo-syntax",
			lazy = false,
			priority = 1000, -- Load early for syntax highlighting
		},
		{ "neovim/nvim-lspconfig", lazy = false },
	},
	opts = {},
	config = function(_, opts)
		M.setup(opts)
	end,
}

return M
