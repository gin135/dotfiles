[ -f ~/.bashrc ] && source ~/.bashrc

### MANPAGERとmanでの色指定

# lvのエスケープシーケンス解釈(+カラー表示)を有効にする
export LV="-c -Sh1;36 -Su1;4;32 -Ss7;37;1;33"

# lessの色設定
export LESS_TERMCAP_mb=$'\E[1;31m'    # begin blinking
export LESS_TERMCAP_md=$'\E[1;36m'    # begin bold
export LESS_TERMCAP_me=$'\E[0m'       # end mode
export LESS_TERMCAP_so=$'\E[1;44;33m' # begin standout-mode - info box
export LESS_TERMCAP_se=$'\E[0m'       # end standout-mode
export LESS_TERMCAP_us=$'\E[4;32m'    # begin underline
export LESS_TERMCAP_ue=$'\E[0m'       # end underline
