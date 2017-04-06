"LaTeX(PDF)ビュワー用キーバインド
autocmd FileType tex nnoremap <buffer> <silent>\v :<C-u>exec "!" . "zathura" . " '%:r.pdf'&"<CR><CR>

".texのファイルタイプをLaTeXにする
let g:tex_flavor = "latex"
"TeX向けの折りたたみを有効にする
let g:tex_fold_enabled=1
"LaTeXコメントでのスペルチェックを無効にする
let g:tex_comment_nospell=1
"verbatim環境ではスペルチェックをする
let g:tex_verbspell=1
"LaTeX用インデント($HOME/.vim/indent/tex.vim)を有効に
let g:tex_indent_items=1

"Syntax_highlightの探索範囲の変更(パフォーマンス向上)
syntax sync maxlines=100
syntax sync minlines=25

"conceal分割ウィンドウ用にスクロール同調をおこなう
autocmd FileType tex setlocal scrollbind
