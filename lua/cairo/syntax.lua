local M = {}

function M.setup_treesitter(opts)
	opts.highlight = opts.highlight or {}
	local disable = opts.highlight.disable or {}

	-- Add Cairo to disabled languages for highlighting if no parser is available
	-- This prevents TS from trying to highlight Cairo files without a parser
	local has_cairo_parser = vim.fn.executable("tree-sitter") == 1
		and pcall(require, "nvim-treesitter.parsers")
		and require("nvim-treesitter.parsers").has_parser("cairo")

	if not has_cairo_parser then
		for i, lang in ipairs(disable) do
			if lang == "cairo" then
				return -- Already disabled, no need to add
			end
		end
		table.insert(disable, "cairo")
	end

	opts.highlight.disable = disable
end

return M
