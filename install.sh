#!/bin/bash

# Cairo Language Server Neovim Setup Installer
# https://github.com/yourusername/your-cairo-repo

set -e # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Config paths
NVIM_CONFIG_DIR="$HOME/.config/nvim"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAIRO_DIR="$SCRIPT_DIR/lua/cairo"

echo -e "${YELLOW}Cairo Language Server Neovim Setup${NC}"
echo "======================================"

# Check if running on Linux/macOS
if [[ "$OSTYPE" != "linux-gnu"* ]] && [[ "$OSTYPE" != "darwin"* ]]; then
  echo -e "${RED}Error: This script only supports Linux and macOS.${NC}"
  exit 1
fi

# Check if Neovim config directory exists
if [[ ! -d "$NVIM_CONFIG_DIR" ]]; then
  echo -e "${RED}Error: Neovim config directory not found: $NVIM_CONFIG_DIR${NC}"
  echo "Please install Neovim and create ~/.config/nvim first."
  exit 1
fi

# Check if cairo directory exists in the repo
if [[ ! -d "$CAIRO_DIR" ]]; then
  echo -e "${RED}Error: Cairo directory not found: $CAIRO_DIR${NC}"
  echo "Make sure you have the lua/cairo/ directory in your repository."
  exit 1
fi

# Check if directory already exists
DEST_DIR="$NVIM_CONFIG_DIR/lua/cairo"
if [[ -d "$DEST_DIR" ]]; then
  echo -e "${YELLOW}Cairo directory already exists in $DEST_DIR${NC}"
  read -p "Do you want to overwrite it? (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
  fi
  echo "Removing existing directory..."
  rm -rf "$DEST_DIR"
fi

# Copy the directory
echo -e "${YELLOW}Installing cairo plugin to $DEST_DIR/...${NC}"
mkdir -p "$NVIM_CONFIG_DIR/lua"
cp -r "$CAIRO_DIR" "$DEST_DIR"

# Make it executable if it has shebang (unlikely for lua, but just in case)
# No need for chmod on directory

# Check for LazyVim/NvChad detection
if [[ -f "$NVIM_CONFIG_DIR/init.lua" ]] || [[ -f "$NVIM_CONFIG_DIR/init.vim" ]]; then
  echo -e "${GREEN}✓ Neovim config found${NC}"

  # Check if it's LazyVim (look for lazy.nvim)
  if [[ -d "$NVIM_CONFIG_DIR/lazy" ]] || grep -q "lazy.nvim" "$NVIM_CONFIG_DIR/init.lua" 2>/dev/null; then
    echo -e "${GREEN}✓ Detected LazyVim or lazy.nvim setup${NC}"
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Restart Neovim"
    echo "2. Run :Lazy sync"
    echo "3. Ensure you have Scarb installed: https://www.cairo-lang.org/docs/install.html"
    echo "4. Test with a .cairo file in a Scarb project"
  else
    echo -e "${YELLOW}Note: This setup is designed for LazyVim. If using a different setup, you may need manual integration.${NC}"
  fi
else
  echo -e "${RED}No standard Neovim config found${NC}"
  echo -e "${YELLOW}If using LazyVim, make sure you have initialized it first${NC}"
fi

echo -e "${GREEN}"
echo "======================================"
echo "Installation complete! 🎉"
echo "======================================"
echo -e "${GREEN}✓ Cairo.lua installed to $PLUGINS_DIR/cairo.lua${NC}"
echo ""
echo -e "${YELLOW}To complete setup:${NC}"
echo "1. Restart Neovim or run :Lazy reload"
echo "2. Run :Lazy sync to install dependencies"
echo "3. Ensure Scarb is installed and on PATH"
echo "   - Install: https://www.cairo-lang.org/docs/install.html"
echo "   - Verify: scarb --version"
echo "4. Test with a Cairo project: scarb new test-project"
echo ""
echo -e "${GREEN}Repo: $SCRIPT_DIR${NC}"
echo "Enjoy Cairo development in Neovim! 🚀"
echo "======================================"
