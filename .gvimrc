set background=dark
set guioptions=m

if has('win32') || has('win64')
    set guifont=Migu\ 1M:h16
else
    set guifont=Migu\ 1M\ 16
endif


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
set lines=40 columns=170
