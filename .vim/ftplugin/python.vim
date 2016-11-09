"PEP 8を守るように、行の折り返し位置をマーキングする
autocmd FileType python
            \ setlocal colorcolumn=80
            \ | highlight colorcolumn ctermfg=red ctermbg=black
