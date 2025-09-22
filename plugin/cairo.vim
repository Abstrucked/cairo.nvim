" Cairo.nvim - Filetype detection and basic commands only
" No keymaps, no LSP setup - that's handled by Lua

if exists('g:loaded_cairo_ft') | finish | endif
let g:loaded_cairo_ft = 1

" Cairo filetype detection
augroup cairo_filetype
  autocmd!
  
  " Cairo source files
  execute 'autocmd BufRead,BufNewFile *.cairo setfiletype cairo'
  
  " Cairo test files
  execute 'autocmd BufRead,BufNewFile */tests/*/*.cairo setfiletype cairo'
  execute 'autocmd BufRead,BufNewFile */test_*/*.cairo setfiletype cairo'
  
  " Cairo lib files
  execute 'autocmd BufRead,BufNewFile */lib/*/*.cairo setfiletype cairo'
augroup END

" Basic fallback commands (Lua will override these when loaded)
if !exists('g:loaded_cairo_lsp')
  command! -nargs=0 CairoCheck echo 'CairoCheck: LSP not loaded - install nvim-lspconfig'
  command! -nargs=0 CairoRestart echo 'CairoRestart: LSP not loaded - install nvim-lspconfig'
  command! -nargs=0 CairoLocateProject echo 'No Cairo project found'
endif

command! -nargs=0 CairoStatus 
  \ lua print(vim.inspect(require('cairo.lsp').clients()))

" Help
command! -nargs=0 CairoHelp 
  \ echo 'Cairo.nvim - LSP support for Cairo language\n' .
  \ 'Commands: :CairoCheck, :CairoRestart, :CairoLocateProject\n' .
  \ 'Status: ' . (exists('g:loaded_cairo_lsp') ? '✅ LSP loaded' : '⚠️  LSP not loaded')
