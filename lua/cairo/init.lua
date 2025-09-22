return {
	-- Cairo syntax (load early so it provides ftdetect/syntax)
	{
		dir = vim.fn.stdpath("data") .. "/site/pack/vendor/start/cairo-1-vim-config",
		name = "cairo-syntax",
		lazy = false,
	},

	-- LSP setup for cairo-language-server via scarb
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "Abstrucked/cairo.nvim" },
		config = function()
			require("cairo.lsp").setup()
		end,
	},

	-- Treesitter configuration
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		event = { "BufReadPre", "BufNewFile" },
		opts = function(_, opts)
			require("cairo.syntax").setup_treesitter(opts)
		end,
	},

	-- Format setup
	{
		"stevearc/conform.nvim",
		optional = true,
		event = { "BufWritePre" },
		opts = function(_, opts)
			require("cairo.format").setup_formatters(opts)
		end,
	},
}
