"Vim内部で使われるエンコーディングの指定
set encoding=utf-8
".vimrcのエンコーディングの指定
scriptencoding utf-8

".vimrc内のautocmdの初期化
autocmd!

"<Leader>キーの指定(Default:'\')
let mapleader='\'
"<LocalLeader>キーの指定
let maplocalleader='\'


" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Plugin ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "{{{

" <<<<<<<<<<<<<<<<<<<< NeoBundle.vim >>>>>>>>>>>>>>>>>>>> "{{{
"NeoBundleは'filetype plugin on'の前に書いておくこと


"vi互換をOFFに
set nocompatible

filetype off
filetype indent plugin off


"Neobundle読込み開始
if has('vim_starting')
    "let g:neobundle#cache_file = "/home/gin/.cache_test/cache"
    if &runtimepath !~ '/neobundle.vim'
        execute 'set runtimepath+=' . expand('$HOME/.bundle/neobundle.vim')
    endif

    let g:neobundle#enable_tail_path = 1
    let g:neobundle#default_options = {
                \ '_' : { 'overwrite' : 0 },
                \ }

endif

call neobundle#begin(expand('~/.bundle'))

"インストールするプラグインの指定
"NeoBundle自身
NeoBundleFetch 'Shougo/neobundle.vim'

""e.g | git clone https://github.com/Shougo/neobundle.vim ~/.bundle/neobundle.vim


NeoBundle 'Shougo/neocomplcache.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/unite.vim',
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'osyo-manga/unite-filetype'
NeoBundle 'tpope/vim-surround'
NeoBundle 'Shougo/unite-help'
NeoBundle 'thinca/vim-quickrun', {
      \ 'commands' : 'QuickRun',
      \ 'mappings' : [
      \   ['nxo', '<Plug>(quickrun)']],
      \ }
NeoBundle 'thinca/vim-ref', { 'autoload' : {
      \ 'ands' : 'Ref'
      \ }}
NeoBundle 'vim-jp/vimdoc-ja'

"未インストールプラグインの確認
"NeoBundleCheck

"NeoBundle読込み終了
call neobundle#end()


"ファイルタイプ判別プラグイン・インデントをONに(NeoBundle後)
filetype plugin indent on

"}}}



" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Plugin_config ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "{{{
" <<<<<<<<<<<<<<<<<<<<<<<<< Unite >>>>>>>>>>>>>>>>>>>>>>>>> "{{{
"Pluginの割り当て用にデフォルトのmapの解除
nnoremap m  <Nop>
xnoremap m  <Nop>

"Uniteが設定を保存するディレクトリ
let g:unite_data_directory = expand('~/.unite')

"Unite起動時にInsertモードにしない
let g:unite_enable_start_insert = 0

"Uniteウィンドウ生成時の画面分割・位置ルールの設定
let g:unite_split_rule = "topleft"
"Uniteウィンドウを垂直分割しない
let g:unite_enable_split_vertically = 0
"Uniteウィンドウが水平分割された時の行数(Default:20)
let g:unite_winheight = 25

"最近使用したファイル履歴の最大保存数(Default:100)
let g:unite_source_directory_mru_limit = 30

"Uniteでの検索キーワードをハイライトする
let g:unite_source_line_enable_highlight = 1

"Unite grepでの表示する候補の最大数
let g:unite_source_grep_max_candidates = 200
"Unite grepでgrepの代わりに(ag|pt|ack)を使う
if executable('ag')
    " Use ag in unite grep source.
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
    \ '-i --line-numbers --nocolor --nogroup --ignore ' .
    \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''
elseif executable('pt')
    " Use pt in unite grep source.
    " https://github.com/monochromegane/the_platinum_searcher
    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor'
    let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
    " Use ack in unite grep source.
    let g:unite_source_grep_command = 'ack-grep'
    let g:unite_source_grep_default_opts =
    \ '-i --no-heading --no-color -k -H'
    let g:unite_source_grep_recursive_opt = ''
endif


"Unite用のPrefix-key
nnoremap [unite] <Nop>
xnoremap [unite] <Nop>
nmap m [unite]
xmap m [unite]
"nmap <C-o> [unite]
"xmap <C-o> [unite]

""Unite向けのマッピング
"""詳しくは:help unite-commandsへ
"uでUnite
nnoremap [unite]u :<C-u>Unite<Space>
";でUnite
nnoremap [unite]; :<C-u>Unite command<CR>
"oでUnite outline
nnoremap [unite]o :<C-u>Unite -vertical -winwidth=60 outline<CR>
"bでUnite buffer
nnoremap [unite]b :<C-u>Unite buffer<CR>
"cでUnite change
nnoremap [unite]c :<C-u>Unite change<CR>
"fでUnite file_point, file, file_mru
nnoremap [unite]ff :<C-u>Unite -buffer-name=files file_point file file_mru<CR>
"fhでUnite file_mru(最近アクセスしたファイルリストを取得)
nnoremap [unite]fh :<C-u>Unite -buffer-name=files file_mru<CR>
"frでUnite file_rec(カレント以下を再帰的に非同期取得)
nnoremap [unite]fr :<C-u>Unite -buffer-name=files file_rec<CR>
"ftでUnite filetype
nnoremap [unite]ft :<C-u>Unite -start-insert -vertical -winwidth=30 filetype<CR>
"tでUnite tag
nnoremap [unite]t :<C-u>Unite tag<CR>
"dでUnite directory, directory_mru
nnoremap [unite]d :<C-u>Unite -buffer-name=files directory directory_mru<CR>
"maでUnite mapping
nnoremap [unite]ma :<C-u>Unite mapping<CR>
"hでUnite help
nnoremap [unite]he :<C-u>Unite -start-insert -winheight=32 help<CR>
"lでUnite locate
nnoremap [unite]l :<C-u>Unite -start-insert locate<CR>
"gでUnite grep
nnoremap [unite]g :<C-u>Unite -buffer-name=search -winheight=20 -no-quit grep<CR>
"ビジュアルモードで選択した単語をUnite grep
vnoremap [unite]g :<C-u>Unite -buffer-name=search -winheight=20 -no-quit grep<CR><CR><C-r><C-w>
"pでUnite process
nnoremap [unite]p :<C-u>Unite -vertical process<CR>
"qでUnite qflist
nnoremap [unite]q :<C-u>Unite -winheight=10 -no-quit qflist<CR>
"rでUnite register, history/yank
nnoremap [unite]r :<C-u>Unite register history/yank<CR>
"vでUnite colorscheme
nnoremap [unite]v :<C-u>Unite -auto-preview -vertical -winwidth=15 colorscheme<CR>
"wでUnite window
nnoremap [unite]w :<C-u>Unite window<CR>
"rmでUnite ref/man
nnoremap [unite]rm :<C-u>Unite ref/man<CR>
"rpでUnite ref/pydoc
nnoremap [unite]rp :<C-u>Unite ref/pydoc<CR>
"neでUnite neobundle
nnoremap [unite]ne :<C-u>Unite -no-split neobundle/
"niでUnite neobundle/install
nnoremap [unite]ni :<C-u>Unite -no-split neobundle/install<CR>
"nuでUnite neobundle/update
nnoremap [unite]nu :<C-u>Unite -no-split neobundle/update<CR>
"nsでUnite neobundle/search
nnoremap [unite]ns :<C-u>Unite -no-split neobundle/search<CR>

"sでUnite source
nnoremap [unite]s :<C-u>Unite -start-insert source<CR>

"}}}



"" <<<<<<<<<<<<<<<<<<<< neocomplete/neocomplcache >>>>>>>>>>>>>>>>>>>> "{{{
" neocomplcache
"neocomplcacheを有効化
let g:neocomplcache_enable_at_startup = 1
"ポップアップメニューに表示する候補最大数
let g:neocomplcache_max_list = 50
"補完候補とするシンタックス・キーワードの最小の長さ
let g:neocomplcache#sources#syntax#min_keyword_length = 3
"数字を選択するクイックマッチを有効化
let g:neocomplcache_enable_quick_match = 1
"ワイルドカード展開をする
let g:neocomplcache_enable_wildcard = 1
"自動補完を開始する長さ
let g:neocomplcache_auto_completion_start_length = 2
"手動補完を開始する長さ
let g:neocomplcache_manual_completion_start_length = 0
"CursorHoldIを使用しない
let g:neocomplcache_enable_cursor_hold_i = 0
"入力してから補完候補を表示するまでの時間(ms)
let g:neocomplcache_cursor_hold_i_time = 500
"自動補完開始時、自動的に候補を選択しない
let g:neocomplcache_enable_auto_select = 0
"camel case補完(大文字をワイルドカードのように扱う)を無効化
let g:neocomplcache_enable_camel_case_completion = 0
"fuzzy補完を無効化
let g:neocomplcache_enable_fuzzy_completion = 0
"_(underbar)区切りの補完をしない
let g:neocomplcache_enable_underbar_completion = 0
"neocomplcacheが使用する一時ファイルのディレクトリ
let g:neocomplcache_temporary_dir = expand('~/.neocom')
"neocomplcacheが使用するsnippetsのディレクトリ
let g:neocomplcache_snippets_dir = expand('~/.vim/snippets')

"オムニ補完をRuby対応にする
let g:neocomplcache_omni_functions = {
            \ 'ruby' : 'rubycomplete#Complete',
            \ }

"キーワード区切りの追加
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns.default = '\h\w*'
let g:neocomplcache_keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

"オムニ補完パターンの追加
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.mail = '^\s*\w\+'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'

"<CR>で補完メニューを閉じつつ改行
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

"}}}



" <<<<<<<<<<<<<<<<<<<< neosnippet >>>>>>>>>>>>>>>>>>>> "{{{
"スニペットディレクトリの指定
let g:neosnippet#snippets_directory = "$HOME/.vim/snippets"
"スニペット補完用マッピング
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
""uniteと連携させる場合
"imap <C-k> <Plug>(neosnippet_start_unite_complete)
"smap <C-k> <Plug>(neosnippet_start_unite_complete)

"<Leader>esでスニペットファイルを編集
nnoremap <Leader>es :<C-u>NeoSnippetEdit -split -vertical -direction=aboveleft<CR>

"スニペットファイルではハードタブを使う
autocmd FileType *snippet setlocal noexpandtab

"スニペットバッファをqだけで閉じれるようにする
autocmd FileType *snippet nnoremap <buffer> q <C-w>c

"}}}



" <<<<<<<<<<<<<<< quickrun.vim >>>>>>>>>>>>>>> "{{{
"quickrunのデフォルトの設定を無効に
let g:quickrun_config = {}
"quickrunのデフォルトのキーマッピングを無効に
let g:quickrun_no_default_key_mappings = 1

"quickrunの実行キーマッピング
nmap <Leader>r <Plug>(quickrun)
nnoremap <Leader>a :<C-u>QuickRun -args ""<Left>
nnoremap <silent> <Leader>s :<C-u>QuickRun -runner shell<CR>
nnoremap <silent> <Leader>m :<C-u>QuickRun >message<CR>

let quickrun_keymaps = {
    \   '<Leader>r' : '>buffer',
    \   '<Leader>s' : '-runner shell',
    \   '<Leader>m' : '>message',
    \}

for [key, com] in items(quickrun_keymaps)
    execute 'nnoremap <silent>' key ':QuickRun' com '-mode n<CR>'
    execute 'vnoremap <silent>' key ':QuickRun' com '-mode v<CR>'
endfor

"quickrunの設定
let g:quickrun_config = {
            \ '_': {
            \   'runner': 'vimproc',
            \   'runner/vimproc/updatetime': '100',
            \   'outputter/buffer/split': ":rightbelow %{winheight(0)/3}sp",
            \   'outputter/buffer/into': 1,
            \   'outputter/buffer/close_on_empty': 1,
            \   }
            \}

"" quickrun_buffer_config
"pLaTeX
let g:quickrun_config['tex'] = {
            \ 'type': 'tex',
            \ 'command': 'latexmk',
            \ 'exec': '%c %s; %c %o',
            \ 'cmdopt': '-c',
            \ 'outputter': 'multi:buffer:quickfix',
            \ 'outputter/buffer/split': ":rightbelow %{winheight(0)/6}sp",
            \ 'outputter/buffer/into': 0,
            \ }

"Markdown
let g:quickrun_config['mkd'] = {
            \ 'type': 'markdown/pandoc',
            \ 'cmdopt': '-s',
            \ 'outputter': 'browser'
            \ }

"HTML
let g:quickrun_config['html'] = {
            \ 'type': 'text/html',
            \ 'outputter': 'browser'
            \ }

"}}}



" <<<<<<<<<<<<<<< vim-indent-guides >>>>>>>>>>>>>>> "{{{
"起動時にインデントのハイライトを有効にする
let g:indent_guides_enable_on_vim_startup = 1
"ガイドを開始するインデントの深さ
let g:indent_guides_start_level = 2
"ガイドを表示するインデントの最大の深さ
let g:indent_guides_indent_levels = 30
"スペースをインデントとみなす
let g:indent_guides_space_guides = 1
"ハイライトの濃さの設定(gvimのみ)
let g:indent_guides_color_change_percent = 25
"ハイライトの幅の設定
let g:indent_guides_guide_size = 1

"ハイライトの色を自動で設定しない
let g:indent_guides_auto_colors = 0

"ハイライトの色の設定
"奇数インデント
autocmd VimEnter,ColorScheme * :hi IndentGuidesOdd  ctermbg=234 guibg=#444444
"偶数インデント
autocmd VimEnter,ColorScheme * :hi IndentGuidesEven ctermbg=237 guibg=#333333

"ハイライトを適用しないファイルタイプの指定
let g:indent_guides_exclude_filetypes = [
        \ 'help',
        \ 'unite',
        \ 'quickrun',
        \ 'quickrun output',
        \ 'tweetvim'
        \ ]

"}}}



" <<<<<<<<<<<<<<< capslock.vim >>>>>>>>>>>>>>> "{{{
"<C-a>で擬似CapsLock切り替え
imap <C-a> <Plug>CapsLockToggle

"}}}



" <<<<<<<<<<<<<<< surround >>>>>>>>>>>>>>> "{{{
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

"}}}



" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "}}}



" ~~~~~~~~~~~~~~~~~~~~~~~~~ .vimrc ~~~~~~~~~~~~~~~~~~~~~~~~~ "{{{

"'<Leader>e[v|g]'で.(g)vimrcを編集
nnoremap <silent><Leader>ev  :<C-u>edit $MYVIMRC<CR> :echo "Opened .vimrc"<CR>
nnoremap <silent><Leader>eg  :<C-u>edit $MYGVIMRC<CR> :echo "Opened .gvimrc"<CR>

"'<Leader>r[v|g]'で.(g)vimrcを再読み込み
nnoremap <silent><Leader>rv :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif <CR> :echo "Finish Loading .vimrc"<CR>
nnoremap <silent><Leader>rg :<C-u>source $MYGVIMRC<CR> :echo "Finish loading .gvimrc"<CR>

".(g)vimrcが変更されたら自動で読み込む
augroup MyAutoCmd
    autocmd!
augroup END

"}}}



" ~~~~~~~~~~~~~~~~~~~~ Command-line_window ~~~~~~~~~~~~~~~~~~~~ "{{{


"Command-line modeの代わりにCommand-line windowを使う
"Command-line windowの行数
set cmdwinheight=3

nnoremap <SID>(command-line-enter) q:
xnoremap <SID>(command-line-enter) q:
nnoremap <SID>(command-line-norange) q:<C-u>

nmap :  <SID>(command-line-enter)
xmap :  <SID>(command-line-enter)

autocmd MyAutoCmd CmdwinEnter * call s:init_cmdwin()

function! s:init_cmdwin()
    nnoremap <buffer><silent> q :<C-u>quit<CR>
    nnoremap <buffer><silent> <TAB> :<C-u>quit<CR>
    nnoremap <buffer><silent> <ESC> :<C-u>quit<CR>

    " Completion.
    "inoremap <buffer><expr><TAB>  pumvisible() ?
    "      \ "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : "\<C-x>\<C-u>\<C-p>"

    " Remove history lines.
    "silent execute printf("1,%ddelete _", min([&history - 20, line("$") - 20]))
    "call cursor(line('$'), 0)

    startinsert!
endfunction"}}}

"}}}



" <<<<<<<<<<<<<<<<<<<< KeyMapping >>>>>>>>>>>>>>>>>>>> "{{{
""普通のmapはnoremap系で! map系は<Plug>以外はできるだけ使わない

"マッピングとキーコードにタイムアウトを設定する
set timeout
"set ttimeout notimeout "キーコードのみに適応する
"マッピングのタイムアウト時間(ms)
set timeoutlen=750
"キーコードのタイムアウト時間(ms)
set ttimeoutlen=100


"誤爆防止の為，"ZZ", "ZQ"を無効にする
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>


""Normalモード以外の時にjjを<ESC>にする
"inoremap jj <ESC>
"onoremap jj <ESC>
"cnoremap jj <C-c>
"inoremap j<Space> j
"onoremap j<Space> j
"cnoremap j<Space> j

"<C-@>でEsc(日本語配列キーボード用)
noremap <C-@> <ESC>
inoremap <C-@> <ESC>

"マクロを'Q'にする(誤爆がうっとうしい & 'q'にマッピングを割り当てるため)
""Ex-modeが使えなくなるけど，めったに使わないからOK
nnoremap Q q

"置換モードと仮想置換モードを入れ替える
nnoremap R gR
nnoremap gR R

"[]<command>でファイル/タブ/quickfixリストの移動ができるようにする
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [B :bfirst<CR>
nnoremap ]B :blast<CR>
nnoremap [a :previous<CR>
nnoremap ]a :next<CR>
nnoremap [A :first<CR>
nnoremap ]A :last<CR>
nnoremap [t :tabnext<CR>
nnoremap ]t :tabprev<CR>
nnoremap [T :tabfirst<CR>
nnoremap ]T :tablast<CR>
nnoremap [c :cnext<CR>
nnoremap ]c :cprev<CR>
nnoremap [C :cfirst<CR>
nnoremap ]C :clast<CR>

" "カッコまでの範囲指定を簡略化する
" nnoremap ( f(
" nnoremap ) f)
" xnoremap ( t(
" xnoremap ) t)

" nnoremap [ f[
" nnoremap ] f]
" xnoremap [ t[
" xnoremap ] t]

" nnoremap { f{
" nnoremap } f}
" xnoremap { t{
" xnoremap } t}

""$を$<Left>に
"nnoremap $ $<Left>
"xnoremap $ $<Left>

"<Space>oで下に空行を挿入
nnoremap <Space>o o<C-[>
"<Space>Oで上に空行を挿入
nnoremap <Space>O O<C-[>

"<Space>pで%
nnoremap <Space>p %
xnoremap <Space>p %
onoremap <Space>p %

"<Space>eで$
nnoremap <Space>e $
xnoremap <Space>e $
onoremap <Space>e $

"<Space>aで*
nnoremap <Space>a *
xnoremap <Space>a *
onoremap <Space>a *


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

"カーソルキー無効
noremap  <up>    <nop>
noremap  <left>  <nop>
noremap  <right> <nop>
noremap  <down>  <nop>
noremap! <up>    <nop>
noremap! <left>  <nop>
noremap! <right> <nop>
noremap! <down>  <nop>
"inoremap <Right> <Nop>
"inoremap <Left> <Nop> "日本語入力時に誤動作する??
"inoremap <Up> <Nop>
"inoremap <Down> <Nop>
"nnoremap <Right> <Nop>
"nnoremap <Left> <Nop>
"nnoremap <Up> <Nop>
"nnoremap <Down> <Nop>

"Insertモード時に<C-]>を<ESC>に(<C-[>とよく誤爆するので)
inoremap <C-]> <ESC>

" "jkでの移動を画面表示の通りにする(折り返し行対策|snippet展開対策)
" nnoremap j gj
" onoremap j gj
" xnoremap j gj
" nnoremap k gk
" onoremap k gk
" xnoremap k gk

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

"Mをmarkにする(mはuniteで使用するので)
nnoremap M m

"最後に編集した場所を選択する
nnoremap gc `[v`]

"<Space>t{num}で見た目上のタブ幅変更
nnoremap <Space>t2 :<C-u>setl tabstop=2<CR>
nnoremap <Space>t4 :<C-u>setl tabstop=4<CR>
nnoremap <Space>t8 :<C-u>setl tabstop=8<CR>

"<Enter>で空行を挿入""Command-line windowで問題出るかも
"nnoremap <Enter> o<ESC>

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

"gvでペーストしたテキストを再選択する
nnoremap <expr> gv '`[' . strpart(getregtype(), 0, 1) . '`]'

"C-R %pでカレントファイルのフルパスを入力
inoremap <expr> <C-R>%p expand('%:p')
"C-R %hでカレントファイルまでのフルパスを入力
inoremap <expr> <C-R>%h expand('%:p:h')

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

"Visualモードでインデント変更後も選択を継続する(逆に使いにくいかも?)
xnoremap < <gv
xnoremap > >gv

"Visualモード時、vで行の(見た目上の)末尾まで選択する
xnoremap v $<Left>

"<C-z>でサスペンドしない(最小化しない)ようにする(GVim)
nnoremap <C-z> <Nop>

"ALTキーにマッピングできるようにする
""ALTは、基本的にxmonadのPrefix-keyとして使うので、Vimでは潰さない方針で
"set winaltkeys=no

" <C-l>で検索時のハイライトを解除する
nnoremap <silent><C-l> :nohlsearch<CR>


"QuickFix用のPrefix-key
nnoremap [Quickfix] <Nop>
nmap q [Quickfix]

"QuickFixウィンドウを[Quickfix]fでトグル可能に
nnoremap [Quickfix]f
            \ :<C-u>call <SID>toggle_quickfix_window()<CR>
function! s:toggle_quickfix_window()
    let _ = winnr('$')
    cclose
    if _ == winnr('$')
        copen
        setlocal nowrap
        setlocal whichwrap=b,s
    endif
endfunction

"Visualモード時に、選択した範囲を連続してインクリメント/デクリメントできるようにする(7.4.754以降)
vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv

" <Space>tでctagsを実行
"nnoremap <Space>t :<C-u>VimShellExecute ctags -R<CR>
nnoremap <Space>t :<C-u>Ctags<CR>
" <Space>htでhelptagsを実行
nnoremap <Space>ht :<C-u>helptags $HOME/.bundle/vimdoc-ja/doc<CR>



"}}}



" <<<<<<<<<<<<<<<<<<<< Prolog >>>>>>>>>>>>>>>>>> "{{{
"拡張子が.plのファイルを開いたら、filetypeをprologにする
""/usr/share/vim/vim74/filetype.vimに、Prologのコードが書かれていれば認識するように設定はされている
au BufNewFile,BufRead *.pl set filetype=prolog

"}}}


" <<<<<<<<<<<<<<<<<<<< Python >>>>>>>>>>>>>>>>>> "{{{
"PEP 8を守るように、行の折り返し位置をマーキングする
autocmd FileType python
            \ setlocal colorcolumn=80
            \ | highlight colorcolumn ctermfg=red ctermbg=black

"}}}


" <<<<<<<<<<<<<<<<<<<< TeX/LaTeX >>>>>>>>>>>>>>>>>>>> "{{{
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

"}}}



" <<<<<<<<<<<<<<<<<<<< reStructuredText >>>>>>>>>>>>>>>>>> "{{{
"restでの<Tab>文字の設定
autocmd FileType rst setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2

"}}}



" <<<<<<<<<<<<<<<<<<<< Scheme >>>>>>>>>>>>>>>>>> "{{{
"Gauche用シンタックス($HOME/.vim/syntax/scheme.vim)を有効に
autocmd FileType scheme :let is_gauche=1

"}}}



" <<<<<<<<<<<<<<<<<<<< Ruby >>>>>>>>>>>>>>>>>> "{{{
""Tab文字と行折り返しをRubyのコーディング規約に合わせる
autocmd FileType ruby setlocal wrap textwidth=79 expandtab shiftwidth=2 softtabstop=2

"}}}



" <<<<<<<<<<<<<<<<<<<< Environment >>>>>>>>>>>>>>>>>>>> "{{{

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

"}}}



" <<<<<<<<<<<<<<<<<<<< Edit >>>>>>>>>>>>>>>>>>>> "{{{
"自動で折り返し＆改行をしない
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


" "行を左・右揃え整形の拡張(justify)
" runtime macros/justify.vim


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

"}}}



" <<<<<<<<<<<<<<<<<<<< Tab >>>>>>>>>>>>>>>>>>>> "{{{
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

"}}}



" <<<<<<<<<<<<<<< Search >>>>>>>>>>>>>>> "{{{
"インクリメンタルサーチ(入力中に検索開始)をする
set incsearch
"検索をファイルの先頭へループしない
set nowrapscan
"検索結果をハイライトする
set hlsearch

"}}}



" <<<<<<<<<<<<<<< Completation >>>>>>>>>>>>>>> "{{{
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

"}}}



" <<<<<<<<<<<<<<< Folding >>>>>>>>>>>>>>> "{{{
"折り畳みをOnにする
set foldenable
"カレントウィンドウに適用される折り畳みの種類
set foldmethod=expr
"折り畳みを行う最小の行数
set foldminlines=10
"折り畳みの入れ子の深さ
set foldnestmax=10
"カーソル移動した時に折り畳みを展開するコマンドの種類の指定
set foldopen=all
"フォーカスが外れたら自動で折りたたむ
set foldclose=all


"}}}



" <<<<<<<<<<<<<<<<<<<< Interface >>>>>>>>>>>>>>>>>>>> "{{{
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
""これをdoubleにしないと、環境によっては二重丸などの表示がおかしくなる << 今のところ問題なし？？
set ambiwidth=single

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

"}}}



" <<<<<<<<<<<<<<<<<<<< Tab&Statsuline >>>>>>>>>>>>>>>>>>>> "{{{

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



" <<<<<<<<<<<<<<< Etc >>>>>>>>>>>>>>> "{{{
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

"muttでvimをメールエディタとして使う際の設定
autocmd BufNewFile,BufRead /tmp/mutt-*
            \ setlocal wrap textwidth=76
            \ |setlocal colorcolumn=76
            \ |highlight colorcolumn ctermbg=lightgray
autocmd FileType mail
            \ setlocal wrap textwidth=76
            \ |setlocal colorcolumn=76
            \ |highlight colorcolumn ctermbg=lightgray

"}}}



" <<<<<<<<<<<<<<< Encoding >>>>>>>>>>>>>>> "{{{
"初期エンコーディング
"カレントバッファのエンコーディングをUTF-8にする
set fileencodings=utf-8
"改行コードの指定(unix:[LF])
set fileformat=unix
"自動判別に使用する改行コードの種類
set fileformats=unix,dos,mac


"文字エンコーディングの自動判別
" The automatic recognition of the character code."{{{
if !exists('did_encoding_settings') && has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'

  " Does iconv support JIS X 0213?
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213,euc-jp'
    let s:enc_jis = 'iso-2022-jp-3'
  endif

  " Build encodings.
  let &fileencodings = 'ucs-bom'
  if &encoding !=# 'utf-8'
    let &fileencodings .= ',' . 'ucs-2le'
    let &fileencodings .= ',' . 'ucs-2'
  endif
  let &fileencodings .= ',' . s:enc_jis
  let &fileencodings .= ',' . 'utf-8'

  if &encoding ==# 'utf-8'
    let &fileencodings .= ',' . s:enc_euc
    let &fileencodings .= ',' . 'cp932'
  elseif &encoding =~# '^euc-\%(jp\|jisx0213\)$'
    let &encoding = s:enc_euc
    let &fileencodings .= ',' . 'cp932'
    let &fileencodings .= ',' . &encoding
  else  " cp932
    let &fileencodings .= ',' . s:enc_euc
    let &fileencodings .= ',' . &encoding
  endif
  let &fileencodings .= ',' . 'cp20932'

  unlet s:enc_euc
  unlet s:enc_jis

  let did_encoding_settings = 1
endif
"}}}

" When do not include Japanese, use encoding for fileencoding.
function! AU_ReCheck_FENC() "{{{
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
        let &fileencoding=&encoding
    endif
endfunction"}}}

autocmd MyAutoCmd BufReadPost * call AU_ReCheck_FENC()

"}}}





" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Fuction ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ "{{{

"" Shell-Gei_formatter "{{{
function! ShellGeiFormatter()
    %s/|/\\|/g
    %s/| /|/g
    :normal ggi#!/bin/sh
endfunction
command! ShellGeiFormatter :call ShellGeiFormatter()
"}}}


"" Rename "{{{
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))
"}}}


"" Coding_Style_Change "{{{
let s:coding_styles = {}
let s:coding_styles['Default']       = 'set noexpandtab tabstop=4 shiftwidth=4 softtabstop&'
let s:coding_styles['Short indent']  = 'set expandtab   tabstop=2 shiftwidth=2 softtabstop&'
let s:coding_styles['GNU']           = 'set expandtab   tabstop=8 shiftwidth=2 softtabstop=2'
let s:coding_styles['BSD']           = 'set noexpandtab tabstop=8 shiftwidth=4 softtabstop&'
let s:coding_styles['Linux']         = 'set noexpandtab tabstop=8 shiftwidth=8 softtabstop&'

command!
            \   -bar -nargs=1 -complete=customlist,s:coding_style_complete
            \   CodingStyle
            \   execute get(s:coding_styles, <f-args>, '')

function! s:coding_style_complete(...) "{{{
    return keys(s:coding_styles)
endfunction "}}}
"}}}


"" File_Encoding_Change "{{{
" Open in UTF-8 again.
command! -bang -bar -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
" Open in iso-2022-jp again.
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
" Open in Shift_JIS again.
command! -bang -bar -complete=file -nargs=? Cp932 edit<bang> ++enc=cp932 <args>
" Open in EUC-jp again.
command! -bang -bar -complete=file -nargs=? Euc edit<bang> ++enc=euc-jp <args>
" Open in UTF-16 again.
command! -bang -bar -complete=file -nargs=? Utf16 edit<bang> ++enc=ucs-2le <args>
" Open in UTF-16BE again.
command! -bang -bar -complete=file -nargs=? Utf16be edit<bang> ++enc=ucs-2 <args>

" Aliases.
command! -bang -bar -complete=file -nargs=? Jis  Iso2022jp<bang> <args>
command! -bang -bar -complete=file -nargs=? Sjis  Cp932<bang> <args>
command! -bang -bar -complete=file -nargs=? Unicode Utf16<bang> <args>
"}}}


"" Handle it in nkf and open. "{{{
command! Nkf !nkf -g %
"}}}


"" Line_Feed_Change "{{{
command! -bang -bar -complete=file -nargs=? Unix edit<bang> ++fileformat=unix <args>
command! -bang -bar -complete=file -nargs=? Mac edit<bang> ++fileformat=mac <args>
command! -bang -bar -complete=file -nargs=? Dos edit<bang> ++fileformat=dos <args>
command! -bang -complete=file -nargs=? WUnix write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? WMac write<bang> ++fileformat=mac <args> | edit <args>
command! -bang -complete=file -nargs=? WDos write<bang> ++fileformat=dos <args> | edit <args>
"}}}


"" CD "{{{
command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>') 
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif

    if a:bang == ''
        pwd
    endif
endfunction

"<Space>cdでCD
nnoremap <Space>cd :<C-u>CD<CR>
"}}}



""}}}
