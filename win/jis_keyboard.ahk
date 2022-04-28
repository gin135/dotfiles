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

Alt & j::AltTab
Alt & k::ShiftAltTab
Alt & l::send {Ctrl down}{LWin down}{Right down}{Ctrl up}{LWin up}{Right up}
Alt & h::send {Ctrl down}{LWin down}{Left down}{Ctrl up}{LWin up}{Left up}
Alt & PgDn::send {Ctrl down}{LWin down}{Right down}{Ctrl up}{LWin up}{Right up}
Alt & PgUp::send {Ctrl down}{LWin down}{Left down}{Ctrl up}{LWin up}{Left up}

Alt & x::send, {Alt down}{F4 down}{Alt up}{F4 up}


; Function 1でサスペンド切り替え

F1::
  Suspend, Toggle
  if(A_IsSuspended)
    MsgBox, Suspended
  else
    MsgBox, Unsuspended
  Return


;; 以下、Windows環境のみ使用可能。何らかのUnix端末を使用すると、バッティングする

;^h::send,{BS}
;^m::send,{ENTER}
