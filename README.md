# cairo.nvim

A Neovim plugin for Cairo language support and Dojo framework integration, providing syntax highlighting, language server integration, and more.

## Features

- Syntax highlighting for Cairo files (.cairo)
- Dojo framework integration (>=1.7.0)
- Cairo Language Server integration via Scarb
- LSP support for code completion, diagnostics, navigation, and formatting
- Cairo-specific buffer commands (`:CairoCheck`, `:CairoRestart`, `:CairoLocateProject`)
- Automatic diagnostic configuration for Cairo files

## Requirements

- Neovim 0.9+
- [Scarb](https://www.cairo-lang.org/docs/install.html) (Cairo package manager)
- [Dojo](https://book.dojoengine.org/) >=1.7.0 (optional, for Dojo framework support)
- [lazy.nvim](https://github.com/folke/lazy.nvim) (for plugin management)

## Installation

### Requirements

- [Scarb](https://docs.swmansion.com/scarb) - Cairo package manager and toolchain
- [conform.nvim](https://github.com/stevearc/conform.nvim) (optional, for formatting support)

### Install Scarb

```bash
curl --proto '=https' --tlsv1.2 -sSf https://install.scarb.sh | sh
```

Verify installation:

```bash
scarb --version
```

### Install Dojo

```bash
curl -L https://install.dojoengine.org | bash
```

Verify installation:

```bash
dojo --version
```

### Using lazy.nvim

Add to your `lazy.lua` configuration:

```lua
require("lazy").setup({
  -- ... other plugins
  {
    "Abstrucked/cairo.nvim",
    ft = "cairo",
    dependencies = {
      "neovim/nvim-lspconfig",
      "stevearc/conform.nvim", -- optional for formatting
    },
    opts = {
      -- optional: customize settings
      root_markers = { "Scarb.toml", "cairo.toml", ".git" },
      settings = {
        cairo = {
          -- cairo-ls specific settings
        },
      },
      diagnostics = {
        virtual_text = true,
        underline = true,
      },
    },
  },
})
```

### Manual Installation

Clone the repository and add to your Neovim path:

```bash
git clone https://github.com/Abstrucked/cairo.nvim ~/.local/share/nvim/cairo.nvim
```

Then add to your lazy configuration:

```lua
require("lazy").setup({
  -- ... other plugins
  { dir = "~/.local/share/nvim/cairo.nvim" },
})
```

## Usage

1. Restart Neovim or run `:Lazy reload`
2. Run `:Lazy sync` to install/update dependencies
3. Open a Cairo file (`.cairo`) in a Scarb or Dojo project
4. The language server should automatically start providing syntax highlighting and LSP features

### Available Commands

When editing a Cairo file, these commands become available:

- `:CairoCheck` - Display detailed LSP status and diagnostics for the current buffer
- `:CairoRestart` - Restart the Cairo LSP for the current buffer
- `:CairoLocateProject` - Locate and open the project root directory

### LSP Features

- **Code Completion**: Press `<C-x><C-o>` or use your completion plugin
- **Go to Definition**: Press `gd` to jump to symbol definitions
- **Hover Information**: Press `K` to show documentation
- **Diagnostics**: Errors and warnings are shown in the buffer

### Formatting

If you have conform.nvim installed, you can format Cairo files with:
- `:ConformFormat` - Format the current buffer
- Visual mode: Select text and format with `gq`
- Or configure your formatter to format on save

## Testing

Create a new Scarb project to test the setup:

```bash
scarb new test-cairo-project
cd test-cairo-project
# Open src/lib.cairo in Neovim
```

Create a new Dojo project to test the setup:

```bash
dojo new test-dojo-project
cd test-dojo-project
# Open src/lib.cairo in Neovim
```

Test the LSP by adding some code and using the commands above!

## Configuration

The plugin comes with sensible defaults. You can customize the LSP settings by modifying the `cairo.lua` file or adding your own configuration.

## Contributing

Contributions are welcome! Please submit issues and pull requests on GitHub.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

