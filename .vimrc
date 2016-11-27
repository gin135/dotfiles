"Vim内部で使われるエンコーディングの指定
set encoding=utf-8
".vimrcのエンコーディングの指定
scriptencoding utf-8



""""" .vimrc

"'<Leader>e[v|g]'で.(g)vimrcを編集
nnoremap <silent><Leader>ev  :<C-u>edit $MYVIMRC<CR> :echo "Opened .vimrc"<CR>
nnoremap <silent><Leader>eg  :<C-u>edit $MYGVIMRC<CR> :echo "Opened .gvimrc"<CR>

"'<Leader>r[v|g]'で.(g)vimrcを再読み込み
nnoremap <silent><Leader>rv :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif <CR> :echo "Finish Loading .vimrc"<CR>
nnoremap <silent><Leader>rg :<C-u>source $MYGVIMRC<CR> :echo "Finish loading .gvimrc"<CR>



""""" keymapping

"マッピングとキーコードにタイムアウトを設定する
set timeout
"set ttimeout notimeout "キーコードのみに適応する
"マッピングのタイムアウト時間(ms)
set timeoutlen=750
"キーコードのタイムアウト時間(ms)
set ttimeoutlen=100

"<Leader>キーの指定(Default:'\')
let mapleader='\'
"<LocalLeader>キーの指定
let maplocalleader='\'


"誤爆防止の為，"ZZ", "ZQ"を無効にする
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

"<C-@>でEsc(日本語配列キーボード用)
noremap <C-@> <ESC>
inoremap <C-@> <ESC>

"<C-h>で:help {topic}
nnoremap <C-h> :<C-u>help<Space>
"helpバッファをqだけで閉じれるようにする
autocmd FileType help nnoremap <buffer> q <C-w>c
"helpバッファの高さ
set helpheight=45
"Kで使用するプログラム(Default:man)
autocmd FileType help setlocal keywordprg=:help
autocmd FileType vim setlocal keywordprg=:help
autocmd FileType python setlocal keywordprg=pydoc
autocmd FileType c setlocal keywordprg=man\ 3
"Kでマニュアルを表示した後、即vimに戻るためのマッピング
nnoremap <silent>K K<CR>
vnoremap <silent>K K<CR>

"Backspaceの挙動
""start:Normalモード移行後に挿入モードに入っても削除できるようにする
""eol:空行をBSで削除できるようにする
""indent:オートインデントのインデントを削除できるようにする
"BackspaceでIndent，EOLを削除できるようにする
"set backspace=indent,eol
"Backspaceですべて削除できるようにする
set backspace=start,eol,indent

"gnで新しいタブを生成
nnoremap gn :<C-u>tabnew<CR>
"L, Hでタブの移動
nnoremap <silent>L :<C-u>tabnext<CR>
nnoremap <silent>H :<C-u>tabNext<CR>

"Yでバッファ全体をレジスタ'+'にヤンク
nnoremap Y "+yy

"i_<C-u>, i_<C-w>の操作を，操作履歴として記録しておく
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

"Command-lineモード時のマッピング
cnoremap <C-a> <Home>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
""次/前のヒストリ
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

"Window分割してない時に<C-w><C-w>で裏バッファに切り替え
nnoremap <silent> <C-w><C-w> :<C-u>call MyWincmdW()<CR>
nnoremap <silent> <C-w>w :<C-u>call MyWincmdW()<CR>
function! MyWincmdW()
    let pn = winnr()
    silent! wincmd w
    if pn == winnr()
        silent! b#
    endif
endfunction


"文字単位、行単位で選択時にも、I, Aを使えるようにする
vnoremap <expr> I  <SID>force_blockwise_visual('I')
vnoremap <expr> A  <SID>force_blockwise_visual('A')

function! s:force_blockwise_visual(next_key)
  if mode() ==# 'v'
    return "\<C-v>" . a:next_key
  elseif mode() ==# 'V'
    return "\<C-v>0o$" . a:next_key
  else  " mode() ==# "\<C-v>"
    return a:next_key
  endif
endfunction


"*，#でキーワード検索する際，移動しないようにする
nnoremap * *N
nnoremap # #N

"Insert, Command-lineモード時にかっこを入力したら中に移動する
noremap! "" ""<Left>
noremap! () ()<Left>
noremap! {} {}<Left>
noremap! '' ''<Left>
noremap! <> <><Left>
noremap! [] []<Left>
noremap! $$ $$<Left>
"autocmd FileType tex noremap! <buffer> <Space><Space> <Space><Space><Left>
autocmd FileType ruby noremap! <buffer> \|\| \|\|<Left>

"Insertモード時に<C-f><C-[hjkl]>でカーソル移動
inoremap <C-f><C-h> <LEFT>
inoremap <C-f><C-j> <DOWN>
inoremap <C-f><C-k> <UP>
inoremap <C-f><C-l> <RIGHT>

"Visualモード時、vで行の(見た目上の)末尾まで選択する
xnoremap v $<Left>

" <C-l>で検索時のハイライトを解除する
nnoremap <silent><C-l> :nohlsearch<CR>

""マクロを'Q'にする(誤爆がうっとうしい & 'q'にマッピングを割り当てるため)
"""Ex-modeが使えなくなるけど，めったに使わないからOK
"nnoremap Q q
"
""QuickFix用のPrefix-key
"nnoremap [Quickfix] <Nop>
"nmap q [Quickfix]
"
""QuickFixウィンドウを[Quickfix]fでトグル可能に
"nnoremap [Quickfix]f
"            \ :<C-u>call <SID>toggle_quickfix_window()<CR>
"function! s:toggle_quickfix_window()
"    let _ = winnr('$')
"    cclose
"    if _ == winnr('$')
"        copen
"        setlocal nowrap
"        setlocal whichwrap=b,s
"    endif
"endfunction

"Visualモード時に、選択した範囲を連続してインクリメント/デクリメントできるようにする(7.4.754以降)
vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv

" <Space>tでctagsを実行
"nnoremap <Space>t :<C-u>VimShellExecute ctags -R<CR>
nnoremap <Space>t :<C-u>Ctags<CR>
" <Space>htでhelptagsを実行
nnoremap <Space>ht :<C-u>helptags $HOME/.bundle/vimdoc-ja/doc<CR>



""""" environment

"シンタックスON
syntax enable "enableは現在の色設定を変更しない(highlightで好みの色に設定可能)
"syntax on "常にデフォルトの色を使用する場合

"Vi互換機能の切替え
"Vi方式の画面描写をおこなう
set cpoptions+=$

"入力待ちをする時間(ms)
set updatetime=5000

"backupファイルを作成しない(:writeが遅くなるので)
set nobackup
"swapファイルを作成する
set swapfile
"undo履歴をファイルに記録する
set undofile

"backup用ファイルディレクトリの指定
set backupdir=$HOME/.vimbackup
if !isdirectory(&backupdir) "無かったら新しく作る
    call mkdir(&backupdir, "p")
endif
"swapファイルディレクトリの指定
set directory=$HOME/.vimbackup
if !isdirectory(&directory) "無かったら新しく作る
    call mkdir(&directory, "p")
endif
"undoファイルディレクトリの指定
set undodir=$HOME/.vimbackup
if !isdirectory(&directory) "無かったら新しく作る
    call mkdir(&directory, "p")
endif


".viminfoを作成しない
set viminfo=

"常に開いているファイルがある場所をカレントディレクトリにする
augroup group_vimrc_cd
    autocmd!
    autocmd BufEnter * execute ":lcd " . (isdirectory(expand("%:p:h")) ? expand("%:p:h") : "")
augroup END

"helpで使用する言語
set helplang=ja,en
"set helplang=en,ja
"日本語help用tagの生成
""毎回やると起動時にすごく重くなるので、関数として手動で実行する
"helptags $HOME/.bundle/vimdoc-ja/doc

"使用する外部シェル
if executable('mksh')
    set shell=mksh
else
    set shell=bash
endif



""""" edit

"自動で{折り返し＆改行}をしない
set textwidth=0
"改行，タブ文字などを表示する
set list
"改行，タブ文字などで表示する記号の指定
set listchars=tab:^\ ,trail:~,extends:»,precedes:«,eol:$,nbsp:%
highlight SpecialKey term=underline ctermfg=green guifg=darkgray

"breakatで指定されて文字のところで行を(画面上だけ)折り返す "!!breakindentと併用すると、行頭の表示がおかしくなる
set nolinebreak
"長い行を折り返して表示する
set wrap
"折り返した行をインデントする(ver 7.4.338以降)
if v:version >= 704
    set breakindent
    set breakindentopt=min:80,shift:1,sbr
endif
"折り返された行の先頭に表示する文字列
let &showbreak = "++ "
"linebreakで折り返しをおこなう文字の指定
set breakat=\ \ ;:,!?

"入力されていない場所にも移動できるようにする
if has('virtualedit')
    set virtualedit=all
endif
"virtualedit時に、テキストの無い場所でペーストした場合、行末にペーストするようにする
if has('virtualedit') && &virtualedit =~# '\<all\>'
    nnoremap <expr> p (col('.') >= col('$') ? '$' : '') . 'p'
endif

"行の連結時にスペースを2つ入れない(行末がピリオドの場合のみ)
set nojoinspaces

"yank時に*レジスタにデータを入るようにする(Visualモード時も含む)(!!GVimのみ)
set clipboard=unnamed,autoselect

"インクリメント・デクリメントをおこなう文字の種類
""8,16進数にする必要のあるときは，set nrformats=octal,hex
set nrformats=octal,hex

"ファイルを開いたとき，最後にカーソルがあった位置まで移動する
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

"Insert, Search時にIMEをoffにする
if has('multi_byte_ime')
    set iminsert=0 imsearch=0
endif



"'%'コマンドによるジャンプ機能の拡張
runtime macros/matchit.vim
"ペアにする単語の設定(単語は\<WORD\>で囲んでおく)
let b:match_words = '\<if\>:\<endif\>'
let b:match_words = '\<if\>:\<fi\>'
let b:match_words = '\<begin\>:\<end\>'
let b:match_words = '\<\\begin{*}\>:\<\\end{*}\>'
let b:match_words = '\<function\>:\<endfunction\>'
let b:match_words = '\<`\>:\<`\>'
"大文字小文字は区別しない
let b:match_ignorecase = 1



""""" tab

"ファイル中の<Tab>文字(Char_code:9)を画面上の見た目で何文字分に展開するか
""既にあるファイルをどのように表示するか指定するときなどに使う
set tabstop=4
"オートインデント(cindent, autoindent)や，シフトオペレータ(>>, <<)で挿入・削除されるインデントの画面上の幅
""要は自動で挿入されるTabの幅のこと
set shiftwidth=4
"キーボードで<Tab>を押した時に挿入される空白の量
""0のときはtabstopと同じ値が使われる
set softtabstop=4
" タブをスペースに展開するかどうか (expandtab:展開する)
"set noexpandtab
set expandtab ""スペースに展開しないとsnippet補完時にタブ幅がおかしくなる

""Vimが自動的に挿入した or <Tab>キーによって挿入された空白は，tabstopで
""設定された幅で<Tab>文字へと自動的に変換される(noexpandtab時)

"インデントの空白数を常にshiftwidthの倍数にする
set shiftround
"行頭の余白内で'Tab'を打ち込むと，'shiftwidth'の数だけインデントする。
set smarttab
"新しい行のインデントを前の行と同じにする
set autoindent
"カッコを考慮してインデントを増減させる
set smartindent
"C言語スタイルのインデントをする
set cindent



""""" search

"インクリメンタルサーチ(入力中に検索開始)をする
set incsearch
"検索をファイルの先頭へループしない
set nowrapscan
"検索結果をハイライトする
set hlsearch

"}}}



""""" completation

"コマンドラインモードで補完を有効にする
set wildmenu
"コマンドライン補完時に，リストを表示して最初のマッチを補完する
set wildmode=list:longest,full
"コマンドライン補完の挙動を変更する単語リストの指定
set wildoptions=tagfile
"小文字・大文字を区別しない
set ignorecase
"ただし，小文字・大文字が混ざった入力は区別する
set smartcase
"ignorecase適用時にマッチした単語の大文字・小文字の区別を打ち込んだテキストに応じて修正する
set infercase

"改行時に自動でコメントアウトしない(nocompatibleより先に書かないとダメっぽい??)
autocmd FileType *  setlocal formatoptions-=cro

"補完ポップアップに表示する情報の指定
set completeopt=menuone
"キーワード補完<C-n>、<C-p>でスキャンするソースの指定
set complete=.,w,b,i,d,t
"set complete=.,w,b,u,t,i,d,k,kspell
"タグ補完時にタグ名と検索パターンの両方を表示する
set showfulltag

"補完ポップアップメニューの高さ
set pumheight=12



""""" interface

"Vim(CUI)で256色が使用できるようにする
set t_Co=256

"Colorscheme
if !exists('g:colors_name') && !has('gui_running')
    colorscheme nevfn
elseif has('gui_running')
    colorscheme desertink
endif


"インタフェースを英語にする
language message C

"入力コマンドを表示する
set showcmd

"「Vimを使ってくれてありがとう」を表示しない
set notitle
"タイトルの最大文字数
set titlelen=80
"行番号を表示しない
set nonumber
"行番号は、カレント行からの相対値で表示しない
set norelativenumber
"閉じ括弧が入力されたとき、対応する括弧を表示する
set showmatch
"showmatch時間の指定
set matchtime=1
"組みとして扱う文字の追加
set matchpairs+=<:>
autocmd FileType cpp,java set matchpairs+==:;

"conceal属性の文字を隠す
""文字を隠す程度の大きさ
set conceallevel=1
""カーソル行のテキストをconceal属性として処理するモードの指定
set concealcursor=c

"TeXにおいて、数式マクロコマンドを記号として表示する
if &filetype == 'tex'
    let g:tex_conceal='adsmg'
    set conceallevel=2
    set concealcursor=c
endif


"コマンドラインの行数
set cmdheight=2
"カーソルの位置情報をステータスラインに表示
set ruler
"ビジュアルベルを使わない
set vb t_vb=
set novisualbell
"新しいウィンドウを右に開く
set splitright
"垂直分割時の境界に使用する文字の指定
set fillchars=stl:\ ,stlnc:=,vert:\|,fold:-,diff:-

"ファイル関連メッセージを一部省略する
set shortmess=imnrxT

"変更された行数を報告をおこなう最小値
set report=0

"スクリプト実行時に画面を再描写しない
set lazyredraw

"ウィンドウ分割時に全てのウィンドウを自動で同じサイズにしない
set noequalalways

"Asian Width class Ambiguous文字(商標，コピーライトマークなど)をASCII文字の2倍の幅で表示する
""これをdoubleにしないと、環境によっては二重丸などの表示がおかしくなる
set ambiwidth=double

"modeline(ファイルに応じた設定を有効にする)をOnに
set modeline

"カーソルの上下に最低でも表示する行数
set scrolloff=2

"Diffモード起動時のオプション
set diffopt=filler,vertical


"全角スペースに下線を引いて見やすくする(Ricty使ってるなら無くてもOK)
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
match ZenkakuSpace /　/


"ポップアップメニューの色
highlight Pmenu ctermbg=darkblue ctermfg=white
highlight PmenuSel ctermbg=darkred ctermfg=white
highlight PmenuSbar ctermbg=darkgray
highlight PmenuThumb ctermbg=lightgray

"incsearchのハイライトの色
highlight IncSearch ctermfg=black ctermbg=yellow
"hlsearchのハイライトの色
highlight Search ctermfg=white ctermbg=yellow



""""" tab, statsuline

"タブラインを必要に応じて表示
set showtabline=1
"ステータスラインを常に表示
set laststatus=2

"ステータスラインの表示内容の設定
""詳細は':help statusline'で
set statusline=[%n]
            \\ %.20t%(%m%r%h%w%)
            \\ %y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}
            \\ %<%.19(%{strftime(\"(%y/%m/%d\ %T)\",getftime(expand(\"%:p\")))}%)
            \\ %=[line:%l,col:%3c%V]
            \\ [dec:%3b,hex:%2B],byte[%o]
            \\ %3P,%L



"Insertモード時にステータスラインの色を変更する
function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline ctermfg=Black ctermbg=Yellow cterm=bold
  elseif a:mode == 'r'
    hi statusline ctermfg=Black ctermbg=Red cterm=bold
  else
    hi statusline ctermfg=Black ctermbg=White cterm=bold
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline ctermfg=Black ctermbg=White cterm=bold

" default the statusline to green when entering Vim
hi statusline ctermfg=Black ctermbg=White cterm=bold



""""" etc

"*レジスタをクリップボードにする
set clipboard=unnamed
"putty使用時にclipboardの起動処理が重くなる現象への対策
"set clipboard=exclude:.*
"<BS>,<Space>使用時，カーソルを行頭・行末で止まらないようにする
set whichwrap=b,s

"Vim終了後にコンソールにVim画面を残さない
set restorescreen
" バッファを保存しなくても他のバッファを表示できるようにする
set hidden



""""" encoding

"初期エンコーディング
"カレントバッファのエンコーディングをUTF-8にする
set fileencodings=utf-8
"改行コードの指定(unix:[LF])
set fileformat=unix
"自動判別に使用する改行コードの種類
set fileformats=unix,dos,mac



""""" fuction

""" Shell-Gei_formatter
function! ShellGeiFormatter()
    %s/|/\\|/g
    %s/| /|/g
    :normal ggi#!/bin/sh
endfunction
command! ShellGeiFormatter :call ShellGeiFormatter()



""""" capslock.vim

"<C-a>で擬似CapsLock切り替え
imap <C-a> <Plug>CapsLockToggle



""""" surround.vim

""囲える文字列の追加
"LaTeX_display_math用
let g:surround_{char2nr("m")} = "\\[ \r \\]"

"文字列を囲む際、前後にスペースを入れないようにする
function! s:define_surround_mapping(key, mapping)
  let var_name = 'surround_'.char2nr(a:key)
  execute 'let b:' . var_name . ' = "' . a:mapping . '"'
endfunction

let dict = {
        \ '(' : "(\r)",
        \ '[' : "[\r]",
        \ '<' : "<\r>",
        \ '{' : "{\r}",
        \ '#':  "#{\r}",
        \ }

for [key, mapping] in items(dict)
  call s:define_surround_mapping(key, mapping)
endfor
