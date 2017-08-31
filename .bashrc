Reset='\[\e[0m\]'       # Text Reset
Black='\[\e[0;30m\]'    # Black - Regular
Red='\[\e[0;31m\]'      # Red
Green='\[\e[0;32m\]'    # Green
Yellow='\[\e[0;33m\]'   # Yellow
Blue='\[\e[0;34m\]'     # Blue
Magenta='\[\e[0;35m\]'   # Purple
Cyan='\[\e[0;36m\]'     # Cyan
White='\[\e[0;37m\]'    # White
bBlack='\[\e[1;30m\]'   # Black - Bold
bRed='\[\e[1;31m\]'     # Red
bGreen='\[\e[1;32m\]'   # Green
bYellow='\[\e[1;33m\]'  # Yellow
bBlue='\[\e[1;34m\]'    # Blue
bMagenta='\[\e[1;35m\]'  # Purple
bCyan='\[\e[1;36m\]'    # Cyan
bWhite='\[\e[1;37m\]'   # White
bgBlack='\[\e[0;40m\]'  # Black - Background
bgRed='\[\e[0;41m\]'    # Red
bgGreen='\[\e[0;42m\]'  # Green
bgYellow='\[\e[0;43m\]' # Yellow
bgBlue='\[\e[0;44m\]'   # Blue
bgMagenta='\[\e[0;45m\]' # Purple
bgCyan='\[\e[0;46m\]'   # Cyan
bgWhite='\[\e[0;47m\]'  # White

########################################

export PATH=$PATH":$HOME/bin:$HOME/.go/bin"
which ruby >/dev/null 2>&1 && export PATH=$PATH":`ruby -e 'print Gem.user_dir'`/bin"
export PAGER=$(which lv 2>/dev/null || which less)
export MANPAGER=$(which lv 2>/dev/null || which less)
export EDITOR=$(which vim 2>/dev/null || which vi)


export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTCONTROL=ignoredups
export HISTIGNORE=cd:exit

export IGNOREEOF=100

umask 022

# フロー制御の無効化
stty stop undef

set editing-mode vi
bind 'set show-mode-in-prompt on'

bind '"\C-l": clear-screen'
bind '"\C-f": forward-char'
bind '"\C-b": backward-char'
bind '"\C-a": beginning-of-line'
bind '"\C-e": end-of-line'
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'
bind '"\C-y": undo'
bind '"\C-e\C-v": edit-and-execute-command'

PROMPT_COMMAND='history -a'
shopt -s histappend

username="${bCyan}\u${bWhite}"
hostname="${bYellow}\H${Reset}"
[ -n "${SSH_CLIENT}" ] && hostname="${bgMagenta}${bWhite}\H${Reset}"
working_dir="${Green}\W${Reset}"
status_code="${bMagenta}\$?${Reset}"
PS1="${username}@${hostname} (${working_dir}) ${status_code} \$ "

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias lr='ls -R'
alias lal='ls -al'
alias l='ls -1'
alias pwd='pwd -P'
alias cls='clear'
alias p='pwd'
alias j='jobs -l'
alias h='fc -l'
alias ed='ed -p :'
alias lv='lv -c'
alias j='jobs -l'
alias ed='ed -p :'
alias pdf='zathura'
alias crontab='crontab -i'
alias halt='halt -p'
alias todo='todo.sh'
alias w3m='w3m -v'
alias feh='feh -.'
alias ruler='echo ----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----A----+----B----+----C----+----D----+----E----+----F'
alias sudo='sudo '
alias ci='ci -zLT'
alias rlog='rlog -zLT'

alias dotpush='(cd ~/dotfiles && hg commit -m "Updated." && hg push)'
alias dotpull='(cd ~/dotfiles && hg pull && hg update)'
alias binpush='(cd ~/bin && hg commit -m "Updated." && hg push)'
alias binpull='(cd ~/bin && hg pull && hg update)'

alias mutt='TERM=screen mutt -F $HOME/.mutt/private/muttrc_priv'
alias muttg='TERM=screen mutt -F $HOME/.mutt/private/muttrc_ginjiro'
alias mutto='TERM=screen mutt -F $HOME/.mutt/private/muttrc_ouj'

alias eng='LANG=C'
alias jp='LANG=ja_JP.UTF-8'

alias info='info --vi-keys'

alias mozcconfig='/usr/lib/mozc/mozc_tool --mode=config_dialog'

alias sohi='source-highlight --failsafe --infer-lang -f esc --style-file=esc.style -i'

alias script='script -fq >(awk '\''{print strftime("[%F %T] ") $0}{fflush() }'\''>> typescript)'


########################################

# 仮想端末間でヒストリを共有する
function share_history {
    history -a
    history -c
    history -r
}
PROMPT_COMMAND='share_history'
shopt -u histappend


# tmuxのタイトルを動的に変更
function preexec () {
  [ ${STY} ] && echo -ne "\ek${1%% *}\e\\"
}

# 引数で渡したファイルの内容を、クリップボードへコピーするやつ
function clip_in()
{
    case $2 in
        c|clip|"")
            sel="clipboard"
            ;;
        p|primary)
            sel="primary"
            ;;
        s|secondary)
            sel="secondary"
            ;;
    esac
    cat $1 | xclip -i -selection $sel
}

# 引数で渡したファイルの内容を、出力するやつ
function clip_out()
{
    case $1 in
        c|clip|"")
            sel="clipboard"
            ;;
        p|primary)
            sel="primary"
            ;;
        s|secondary)
            sel="secondary"
            ;;
    esac
    xclip -o -selection $sel
}

# 計算用関数
function calc()
{
    awk "BEGIN{print $*}"
}
