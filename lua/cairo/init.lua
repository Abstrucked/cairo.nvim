-- Set file type for .cairo files

vim.filetype.add({

  extension = {

    cairo = "cairo",

  },

})

-- LSP setup

local ok, lspconfig = pcall(require, "lspconfig")

if ok then

  lspconfig.cairo.setup({

    cmd = { "cairo-language-server" },

    filetypes = { "cairo" },

    root_dir = lspconfig.util.root_pattern("Scarb.toml", "cairo.toml", ".git"),

    -- Add any other options here

  })

else

  vim.notify("lspconfig not found, cairo LSP not set up", vim.log.levels.WARN)

end

-- Treesitter setup

local ok_ts, ts = pcall(require, "nvim-treesitter")

if ok_ts then

  ts.setup({

    highlight = {

      enable = true,

      additional_vim_regex_highlighting = false,

    },

    ensure_installed = { "cairo" }, -- This will install the parser if not present

  })

else

  vim.notify("nvim-treesitter not found, cairo syntax highlighting not set up", vim.log.levels.WARN)

end

-- Conform setup for formatting

local ok_conform, conform = pcall(require, "conform")

if ok_conform then

  conform.formatters.cairo = {

    command = "scarb",

    args = { "fmt", "$FILENAME" },

    stdin = false,

  }

  conform.setup({

    formatters_by_ft = {

      cairo = { "cairo" },

    },

  })

else

  vim.notify("conform not found, cairo formatting not set up", vim.log.levels.WARN)

end
