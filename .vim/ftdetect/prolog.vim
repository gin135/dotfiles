"拡張子が.plgのファイルを開いたら、filetypeをprologにする
""/usr/share/vim/vim74/filetype.vimに、Prologのコードが書かれていれば認識するように設定はされている
autocmd BufNewFile,BufRead *.plg setfiletype=prolog
