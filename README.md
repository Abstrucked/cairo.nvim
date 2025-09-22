# cairo.nvim

A Neovim plugin for Cairo language support, providing syntax highlighting, language server integration, and more.

## Features

- Syntax highlighting for Cairo files (.cairo)
- Cairo Language Server integration
- LSP support for code completion, diagnostics, and navigation

## Requirements

- Neovim 0.9+
- [Scarb](https://www.cairo-lang.org/docs/install.html) (Cairo package manager)
- [lazy.nvim](https://github.com/folke/lazy.nvim) (for plugin management)

## Installation

### Using the Install Script

Run the provided install script to automatically copy the plugin files to your Neovim configuration:

```bash
./install.sh
```

The script will:
- Copy `lua/cairo.lua` to `~/.config/nvim/lua/plugins/cairo.lua`
- Create the plugins directory if it doesn't exist

### Manual Installation

If you prefer manual installation, copy the `lua/cairo` directory to your Neovim configuration:

```bash
mkdir -p ~/.config/nvim/lua
cp -r lua/cairo ~/.config/nvim/lua/
```

Then add the plugin to your `lazy.lua` configuration:

```lua
require("lazy").setup({
  -- ... other plugins
  { dir = "~/.config/nvim/lua/cairo" },
})
```

### Direct Installation via Lazy

If the repository is published on GitHub, you can install it directly in your Lazy configuration:

```lua
require("lazy").setup({
  -- ... other plugins
  { "Abstrucked/cairo.nvim" },
})
```

## Usage

1. Restart Neovim or run `:Lazy reload`
2. Run `:Lazy sync` to install/update dependencies
3. Open a Cairo file (`.cairo`) in a Scarb project
4. The language server should automatically start providing syntax highlighting and LSP features

## Testing

Create a new Scarb project to test the setup:

```bash
scarb new test-cairo-project
cd test-cairo-project
# Open src/lib.cairo in Neovim
```

## Configuration

The plugin comes with sensible defaults. You can customize the LSP settings by modifying the `cairo.lua` file or adding your own configuration.

## Contributing

Contributions are welcome! Please submit issues and pull requests on GitHub.

## License

[Your License Here]

