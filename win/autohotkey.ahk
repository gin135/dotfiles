; JIS配列のキーボードを、US配列に変換するマッピング
; キーボードがJIS配列のラップトップ機にUSキーボードを接続し、かつレジストリを弄らない場合に使う

VKF4::Send,{``}
+VKF4::Send,{~}
*"::send, @
*&::send, {^}
*'::send, &
*(::send, *
*)::send, (
*+0::send, )
*=::send, _
*^::send, =
*~::send, {+}
*@::send, [
*^@::send, ^[
*`::send, {{}
*[::send, ]
*{::send, {}}
*]::send, \
*}::send, |
*+::send, :
+*::send, "
*vkBA::send, '

; 仮想デスクトップ用マッピング
Alt & j::send {Alt down}{Tab down}{Alt up}{Tab up}
Alt & k::send {Alt down}{Shift down}{Tab down}{Alt up}{Shift up}{Tab up}
Alt & l::send {Ctrl down}{LWin down}{Right down}{Ctrl up}{LWin up}{Right up}
Alt & h::send {Ctrl down}{LWin down}{Left down}{Ctrl up}{LWin up}{Left up}

Alt & x::send, {Alt down}{F4 down}{Alt up}{F4 up}

Alt & 1::send, {Ctrl down}{Lwin down}{Left down}{Left up}{Left down}{Left up}{Left down}{Left up}{Lwin up}{Ctrl up}
Alt & 2::send, {Ctrl down}{Lwin down}{Left down}{Left up}{Left down}{Left up}{Left down}{Left up}{Right down}{Right up}{Lwin up}{Ctrl up}
Alt & 3::send, {Ctrl down}{Lwin down}{Right down}{Right up}{Right down}{Right up}{Right down}{Right up}{Left down}{Left up}{Lwin up}{Ctrl up}
Alt & 4::send, {Ctrl down}{Lwin down}{Right down}{Right up}{Right down}{Right up}{Right down}{Right up}{Lwin up}{Ctrl up}


;; 以下、Windows環境のみ使用可能。何らかのUnix端末を使用すると、バッティングする
;^h::send,{BS}
;^m::send,{ENTER}
