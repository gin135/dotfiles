"拡張子が.plのファイルを開いたら、filetypeをprologにする
""/usr/share/vim/vim74/filetype.vimに、Prologのコードが書かれていれば認識するように設定はされている
autocmd BufNewFile,BufRead *.pl setfiletype=prolog
