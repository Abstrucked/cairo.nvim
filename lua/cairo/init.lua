return {
	-- Cairo syntax (load early so it provides ftdetect/syntax)
	{
		"amanusk/cairo-1-vim-config",
		lazy = false,
	},

	-- LSP setup for cairo-language-server via scarb
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local configs = require("lspconfig.configs")
			local util = require("lspconfig.util")

			local scarb = vim.fn.exepath("scarb")
			local cmd
			if scarb ~= "" then
				cmd = { scarb, "cairo-language-server" }
			elseif vim.fn.exepath("cairo-language-server") ~= "" then
				cmd = { vim.fn.exepath("cairo-language-server") }
			else
				cmd = { "scarb", "cairo-language-server" }
			end

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
					},
				}
			else
				configs.cairo_ls.default_config.cmd = cmd
			end

			lspconfig.cairo_ls.setup({})
		end,
	},

	-- Optional: disable TS highlighting for cairo if you don't have a parser
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = function(_, opts)
			opts.highlight = opts.highlight or {}
			local disable = opts.highlight.disable or {}
			table.insert(disable, "cairo")
			opts.highlight.disable = disable
		end,
	},

	-- Format setup via conform.nvim with scarb fmt
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters = opts.formatters or {}

			local scarb = vim.fn.exepath("scarb")
			if scarb ~= "" then
				opts.formatters["cairo-scarb-fmt"] = {
					command = scarb,
					args = { "fmt", "$FILENAME" },
					stdin = false,
					cwd = require("conform.util").root_file({ "Scarb.toml", ".git" }),
				}
				opts.formatters_by_ft.cairo = { "cairo-scarb-fmt" }
			end

			return opts
		end,
	},
}
