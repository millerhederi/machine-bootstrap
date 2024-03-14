" Ensure Git commit messages are recognized as gitcommit filetype
autocmd BufRead,BufNewFile *COMMIT_EDITMSG* set filetype=gitcommit

" Git commit message specific settings
autocmd FileType gitcommit setlocal colorcolumn=51
autocmd FileType gitcommit highlight ColorColumn ctermbg=lightgrey guibg=lightgrey