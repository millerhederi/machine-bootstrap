" Ensure Git commit messages are recognized as gitcommit filetype
autocmd BufRead,BufNewFile *COMMIT_EDITMSG* set filetype=gitcommit

" Git commit message specific settings
autocmd FileType gitcommit setlocal textwidth=72
autocmd FileType gitcommit setlocal colorcolumn=51,73
autocmd FileType gitcommit highlight ColorColumn ctermbg=lightgrey guibg=lightgrey