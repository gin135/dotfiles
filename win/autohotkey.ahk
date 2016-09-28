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
@::send, [
<+!#@::send, [
^@::send, ^[
*`::send, {{}
*[::send, ]
*{::send, {}}
*]::send, \
*}::send, |
*+::send, :
+*::send, "
*vkBA::send, '
