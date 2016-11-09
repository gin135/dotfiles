"muttでvimをメールエディタとして使う際の設定
autocmd BufNewFile,BufRead /tmp/mutt-*
            \ setlocal wrap textwidth=76
            \ |setlocal colorcolumn=76
            \ |highlight colorcolumn ctermbg=lightgray
autocmd FileType mail
            \ setlocal wrap textwidth=76
            \ |setlocal colorcolumn=76
            \ |highlight colorcolumn ctermbg=lightgray

