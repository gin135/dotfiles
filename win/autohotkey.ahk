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

Alt & j::send {Alt down}{Tab down}{Alt up}{Tab up}
Alt & k::send {Alt down}{Shift down}{Tab down}{Alt up}{Shift up}{Tab up}

;; 以下、Windows環境のみ使用可能。何らかのUnix端末を使用すると、バッティングする
;^h::send,{BS}
;^m::send,{ENTER}
