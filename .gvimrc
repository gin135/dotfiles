
set background=dark

set guioptions=m

if has('win32') || has('win64')
    set guifont=Ricty:h14
else
    set guifont=Ricty\ 14
endif
"set guifontwide=Ricty\ 14

"set guifont=Droid\ Sans\ Mono\ 12
"set guifontwide=Droid\ Sans\ Mono\ 12

"set guifont=Dejavu\ Sans\ Mono\ 12
"set guifontwide=Dejavu\ Sans\ Mono\ 12


"マウス設定
set mouse=a
set nomousefocus
set mousehide
set mousemodel=popup


"GUI Window設定
"GUIウィンドウを合わせるときに，画面の高さから差し引かれるピクセル数
set guiheadroom=-20
"ウィンドウ位置
"winpos 10 5
"列・行数
"set lines=36 columns=132
set lines=36 columns=134



"}}}




"" 日本語入力に関する設定:
""
"if has('multi_byte_ime') || has('xim')
"  " IME ON時のカーソルの色を設定(設定例:紫)
"  highlight CursorIM guibg=Purple guifg=NONE
"  " 挿入モード・検索モードでのデフォルトのIME状態設定
"  set iminsert=0 imsearch=0
"  if has('xim') && has('GUI_GTK')
"    " XIMの入力開始キーを設定:
"    " 下記の s-space はShift+Spaceの意味でkinput2+canna用設定
"    "set imactivatekey=s-space
"  endif
"  " 挿入モードでのIME状態を記憶させない場合、次行のコメントを解除
"  inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
"endif
"
"if has('multi_byte_ime')
"  highlight Cursor guifg=Yellow guibg=Blue
"  highlight CursorIM guifg=Green guibg=Purple
"endif


"""""""""""""""""""""""""""""""
""挿入モード時、ステータスラインの色を変更
"""""""""""""""""""""""""""""""
"let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'
"
"if has('syntax')
"  augroup InsertHook
"    autocmd!
"    autocmd InsertEnter * call s:StatusLine('Enter')
"    autocmd InsertLeave * call s:StatusLine('Leave')
"  augroup END
"endif
"
"let s:slhlcmd = ''
"function! s:StatusLine(mode)
"  if a:mode == 'Enter'
"    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
"    silent exec g:hi_insert
"  else
"    highlight clear StatusLine
"    silent exec s:slhlcmd
"  endif
"endfunction
"
"function! s:GetHighlight(hi)
"  redir => hl
"  exec 'highlight '.a:hi
"  redir END
"  let hl = substitute(hl, '[\r\n]', '', 'g')
"  let hl = substitute(hl, 'xxx', '', '')
"  return hl
"endfunction
