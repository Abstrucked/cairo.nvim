" Cairo.nvim: Cairo language support for Neovim
" Author: Abstrucked
" Description: LSP, syntax, and formatting support for Cairo language

if exists('g:loaded_cairo') | finish | endif
let g:loaded_cairo = 1

" Cairo file detection
augroup cairo_filetype
  autocmd!
  autocmd BufRead,BufNewFile *.cairo setfiletype cairo
augroup END

" Commands
command! CheckCairoLSP lua require('cairo.lsp').check_lsp()
command! CairoFmt lua require('conform').format({ bufnr = 0, filetype = 'cairo' })

" Key mappings (optional - can be customized)
augroup cairo_mappings
  autocmd!
  autocmd FileType cairo nnoremap <buffer><silent> <leader>cf :CairoFmt<CR>
  autocmd FileType cairo nnoremap <buffer><silent> <leader>cl :CheckCairoLSP<CR>
augroup END

" Status line integration (optional)
if exists('g:statusline_components') && has_key(g:statusline_components, 'cairo')
  unlet g:statusline_components.cairo
endif
let g:statusline_components = get(g:statusline_components, {}, {})
let g:statusline_components.cairo = '%{exists("g:loaded_cairo") ? " 🐪" : ""}'
