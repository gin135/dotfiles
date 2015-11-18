# .zshrcの自動再コンパイル
if [ ! -e $HOME/.zshrc.zwc -o $HOME/.zshrc.zwc -ot `/bin/readlink $HOME/.zshrc` ]; then
    zcompile $HOME/.zshrc
fi


# ifでzshが特定バージョン以上のとき，の条件を使えるようにする(ref:zshcontrib)
autoload -Uz is-at-least


#============================================================================
# for Emacs
#============================================================================

function emacs()
{
    ADDITION_COMMAND=
    OPTIONS=

    while getopts :nw OPT
    do
        case $OPT in
            n|w)
                if [ `whence -p sl` ]; then
                    ADDITION_COMMAND="sl -a"
                fi
                OPTIONS="-s" ;;
            *)
                ;;
        esac
    done
    shift $(($OPTIND - 1))

    eval $ADDITION_COMMAND && ed $OPTIONS -p emacs:
}



#============================================================================
# PATH
#============================================================================

# 重複するPATHは無視させる
typeset -U path

#texlive_version="20`date +%y`"
#texlive_version="2013"
#TEX_PATH=":/usr/local/texlive/$texlive_version/bin/$CPUTYPE-linux"

PATH=$PATH":$HOME/bin:$HOME/.cabal/bin:$HOME/.go/bin"
PATH=$PATH":`ruby -e 'print Gem.user_dir'`/bin"
GOPATH="$HOME/.go"
#MANPATH=$MANPATH":/usr/local/texlive/$texlive_version/texmf/doc/man"
#INFOPATH=$INFOPATH":/usr/local/texlive/$texlive_version/texmf/doc/info"



#============================================================================
# Environment
#============================================================================

# 言語の自動設定
if [ $UID -eq 0 ]; then #rootの場合
    export LANG=C
elif [ $TERM = "linux" ]; then #CUIの場合
    export LANG=C
elif [ $SHLVL -gt 1 ]; then #シェル深度が1より大きいなら無視
else #どれでもないならUTF-8に
    export LANG=ja_JP.UTF-8
fi

# パーミッション初期値の設定(e.g. file:666-022=644, dir:777-022=755)
umask 022

# ページャの設定
if [ `whence -p lv` ]; then
    export PAGER=lv
    export MANPAGER=lv
else
    export PAGER=less
    export MANPAGER=less
fi

# エディタの指定
export EDITOR=vim

# ブラウザの指定
export BROWSER=chromium
#export BROWSER=chrome

#arch-wiki-docsを開くブラウザの指定
export wiki_browser=w3m



#============================================================================
# Directory_Control
#============================================================================

# 自動でpushd cd -[TAB]
setopt auto_pushd
# 重複してpushしない
setopt pushd_ignore_dups
# ディレクトリスタックの上限
export DIRSTACKSIZE=15

# ディレクトリスタック一覧呼出し&選択関数dir()
function dir() {
    dirs -pv
    echo -n "select number : "
    read newdir
    cd +"$newdir"
}


# 存在しないディレクトリを指定した場合，~付きディレクトリとして扱う(変数展開を試みる)
setopt cdable_vars

# cd時に指定パスに'..'が含まれている場合、物理パスの位置から見た親ディレクトリに変換する(下記例参照)
#setopt chase_dots

# chase_dotsを、パスにシンボリックリンクが含まれている場合にも適用する
#setopt chase_links

## chase_dotsの例
# $ unsetopt chase_dots; ln -s /var/log $HOME/; cd ~/log/..; pwd
# $HOME
# $ setopt chase_dots; ln -s /var/log $HOME/; cd ~/log/..; pwd
# /var/log

## chase_linksの例
# $ unsetopt chase_links; ln -s $HOME/Dropbox/dotfiles $HOME/; cd ~/dotfiles/..; pwd
# $HOME/dotfiles
# $ setopt chase_links; ln -s $HOME/Dropbox/dotfiles $HOME/; cd ~/dotfiles/..; pwd
# $HOME/Dropbox/dotfiles


#============================================================================
# History
#============================================================================

# ヒストリファイルの指定
HISTFILE=~/.zsh_history
# メモリ内の最大ヒストリ数
HISTSIZE=100000
# ヒストリファイルの最大ヒストリ数
SAVEHIST=100000

if [ $UID = 0 ]; then #rootの場合、ヒストリを作成しない
    unset HISTFILE
    SAVEHIST=0
fi

# ヒストリファイルに上書きではなく追記する(Default:On)
setopt append_history

# ヒストリファイルを拡張フォーマットで保存"しない"
unsetopt extended_history

# ヒストリベル無効化
unsetopt hist_beep

# 重複するコマンドは無視
setopt hist_ignore_dups #1つ前と同じなら登録しない
setopt hist_ignore_all_dups #過去に登録済みならそれを削除

# ヒストリ参照コマンド(history, fc)は登録しない
setopt hist_no_store

# 先頭にスペースがあるコマンドはヒストリに登録しない
setopt hist_ignore_space

# ヒストリ登録時に余分なスペースを削除
setopt hist_reduce_blanks

# ヒストリ展開子使用時に即実行する
unsetopt hist_verify

# 関数定義はヒストリに登録しない
setopt hist_no_functions

# ヒストリ参照コマンドは登録しない
setopt hist_no_store

# 異なるPIDのシェルでヒストリを共有する
setopt share_history

# 補完時にヒストリを自動的に展開
# setopt hist_expand #'!'とか入力した時に誤爆するので一時無効

# 入力の途中でもC^P, C^Nでヒストリ検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey -v '^P' history-beginning-search-backward-end
bindkey -v '^N' history-beginning-search-forward-end
bindkey -a '^P' history-beginning-search-backward-end
bindkey -a '^N' history-beginning-search-forward-end
# #複数行の編集はカーソルキーを使う


# glob展開可能な履歴のインクリメンタル検索
bindkey -v '^R' history-incremental-pattern-search-backward
bindkey -v '^S' history-incremental-pattern-search-forward
bindkey -a '?' history-incremental-pattern-search-backward
bindkey -a '/' history-incremental-pattern-search-forward



#============================================================================
# Bindkey
#============================================================================

# コマンドラインをエディタで編集できるようにする
autoload -Uz edit-command-line
zle -N edit-command-line

# キーバインドをvi風にする
bindkey -v

# ----------vi-insert mode----------
# <C-f>で1文字進む
bindkey -v '^F' forward-char
# <C-b>で1文字戻る
bindkey -v '^B' backward-char

# <C-y>でundo
bindkey -v '^Y' vi-undo-change

# <C-u>をカーソルの左側だけ削除
bindkey -v '^U' backward-kill-line

# <C-a>, <C-e>で行の頭と終りに移動(邪道かも)
bindkey -v '^A' vi-beginning-of-line
bindkey -v '^E' vi-end-of-line

# <C-o>で現在の行をコマンドラインスタックに積む
bindkey -v '^O' push-line

# <C-e><C-v>で現在の行をエディタで編集する
bindkey -v '^E^V' edit-command-line


# ----------vi-command mode----------
# <C-o>で現在の行をコマンドラインスタックに積む
bindkey -a '^O' push-line

# Normal_mode時に<C-m>で<CR>+Insert_modeに移行
vicmd_accept-line(){
    zle accept-line
    zle vi-insert
}
zle -N vicmd_accept-line
bindkey -a '^M' vicmd_accept-line



#============================================================================
# Prompt
#============================================================================

# プロンプトをカラー表示にする
autoload -U colors
colors
# プロンプト内で変数展開・コマンド置換・算術演算をできるようにする
setopt prompt_subst
# コマンド実行後に右プロンプトを消す
setopt transient_rprompt

# ----------色の定義----------
GREEN="%{${fg[green]}%}"
BLUE="%{${fg[blue]}%}"
RED="%{${fg[red]}%}"
CYAN="%{${fg[cyan]}%}"
MAGENTA="%{${fg[magenta]}%}"
YELLOW="%{${fg[yellow]}%}"
BLACK="%{${fg[black]}%}"
WHITE="%{${fg[white]}%}"
bGREEN="%{${fg_bold[green]}%}"
bBLUE="%{${fg_bold[blue]}%}"
bRED="%{${fg_bold[red]}%}"
bCYAN="%{${fg_bold[cyan]}%}"
bMAGENTA="%{${fg_bold[magenta]}%}"
bYELLOW="%{${fg_bold[yellow]}%}"
bBLACK="%{${fg_bold[black]}%}"
bWHITE="%{${fg_bold[white]}%}"
BG_GREEN="%{${bg[green]}%}"
BG_BLUE="%{${bg[blue]}%}"
BG_RED="%{${bg[red]}%}"
BG_CYAN="%{${bg[cyan]}%}"
BG_MAGENTA="%{${bg[magenta]}%}"
BG_YELLOW="%{${bg[yellow]}%}"
BG_BLACK="%{${bg[black]}%}"
BG_WHITE="%{${bg[white]}%}"

BOLD="%B"
RESET="%{${reset_color}%}"



#---------- プロンプト用変数の指定----------
# hook用の関数をロード
autoload -Uz add-zsh-hook


# ホスト名(リモートの場合は強調表示)
if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
    prompt_host="${BG_MAGENTA}${bCYAN}${HOST}${RESET}"
else
    prompt_host="${bYELLOW}$HOST${RESET}"
fi



# OS名|zshバージョン(lsb_releaseがあればディストリ名，無ければOS名)
if [ $COLUMNS -le 60 ]; then #($COLUMNSがかなり少ない場合は表示しない)
    prompt_ver=""
elif [ `whence -p lsb_release` ]; then
    p_distri_name=`lsb_release --id --release --codename --short | tr '\n' ' ' | sed -e 's/ $/\n/'`
    if [ ${p_distri_name} = "Arch rolling n/a" ]; then
        p_distri_name="Arch Linux"
    fi

    if [ $COLUMNS -le 100 ]; then #$COLUMNSが少なければアーキテクチャ名は表示しない
        prompt_ver="(${MAGENTA}${p_distri_name}${RESET}|${YELLOW}${ZSH_VERSION}${RESET})"
    elif [ $p_distri_name = "Arch Linux" ] ; then
        prompt_ver="(${MAGENTA}${p_distri_name} ${CPUTYPE} `uname -r`${RESET}|${YELLOW}zsh ${ZSH_VERSION}${RESET})"
    else
        prompt_ver="(${MAGENTA}${p_distri_name} ${CPUTYPE}${RESET}|${YELLOW}zsh ${ZSH_VERSION}${RESET})"
    fi
else
    p_os_name=`uname -o`
    if [ $COLUMNS -le 100 ]; then
        prompt_ver="(${MAGENTA}${p_os_name}${RESET}|${YELLOW}${ZSH_VERSION}${RESET})"
    else
        prompt_ver="(${MAGENTA}${p_os_name} ${CPUTYPE}${RESET}|${YELLOW}zsh ${ZSH_VERSION}${RESET})"
    fi
fi



# IPの取得
if_num=0
prompt_if=
prompt_ip=

for if_type in "eth" "wlan" "venet" "usb"; do
    # if [ $OSTYPE = "cygwin" ]; then
    #     prompt_ip=`netsh interface ip show addresses "ローカル エリア接続" | nkf -u | grep IP | awk -F'  +' '{print $3}'`
    #     break
    # fi
    for if_num in `seq 0 2`; do
        prompt_ip=`LANG=C /sbin/ip addr show "${if_type}${if_num}" 2> /dev/null | grep 'inet .* scope global' | awk -F' ' '{print $2}'`
        if [ ${#prompt_ip} -ne 0 ]; then
            break
        fi
    done
    if [ ${#prompt_ip} -ne 0 ]; then
        prompt_if=${if_type}$(($if_num))
        break
    fi
    if_num=0
done



# インタフェース，IPアドレス($COLUMNSが少ない場合は簡略表記にする)
if [ -z $prompt_ip ]; then
    prompt_ifip="(${MAGENTA}Not Connected${RESET})"
elif [ $COLUMNS -le 80 -o $OSTYPE = "cygwin" ]; then
    prompt_ifip="(${bMAGENTA}$prompt_ip${RESET})"
else
    prompt_ifip="(${CYAN}$prompt_if${RESET}:${bMAGENTA}$prompt_ip${RESET})"
fi



#CPU_Governor
#prompt_govern="gov:`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`"

#Uptime
#p_uptime_logins=`uptime`
#prompt_uptime=``

#Login_Users



# ヒストリ数
prompt_hist="[${GREEN}H${RESET}:${GREEN}%h${RESET}]"



# ユーザ名(rootの場合は強調表示)
if [ $UID -eq 0 ]; then
    prompt_user="*${BOLD}${BG_RED}$USERNAME${RESET}*"
    prompt_symbol="${BOLD}${BG_RED}#${RESET}"
else
    prompt_user="${bCYAN}$USERNAME${RESET}"
    prompt_symbol="$"
fi


# 前コマンドの返り値
prompt_ret="%(?,,${BG_RED}:-(${RESET} )"


# ジョブ数(バックグラウンドジョブがあるときのみ)
prompt_jobs="%(1j,(${bRED}J:%j${RESET}),)"



# VCSのブランチ名の取得
if is-at-least 4.3.10 && [ $OSTYPE != 'cygwin' ]; then #version 4.3.10以上のみ有効
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git svn hg bzr
    zstyle ':vcs_info:*' formats '%s:%b'
    # zstyle ':vcs_info:*' formats '%F{white}%c%u%s%f%F{white}:%f%F{green}__branch-name__%f' '%b' '%r'
    zstyle ':vcs_info:*' actionformats '%s:%b|%a'
    zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
    zstyle ':vcs_info:bzr:*' use-simple true


#    #リポジトリの変更の監視
#    #リポジトリが大きいとかなり重くなるので注意!!
#    zstyle ':vcs_info:git:*' check-for-changes true
#    zstyle ':vcs_info:git:*' stagedstr "+"
#    zstyle ':vcs_info:git:*' unstagedstr "-"
#    zstyle ':vcs_info:git:*' formats '(%s)-[%b] %c%u'
#    zstyle ':vcs_info:git:*' actionformats '(%s)-[%b|%a] %c%u'

    function _update_vcs_info_msg() {
        psvar=()
        LANG=C vcs_info
        [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
    }
    add-zsh-hook precmd _update_vcs_info_msg
fi

# VCSブランチ名
prompt_vcs="%1(v|(${GREEN}%1v%f${RESET})|)"



# カレントディレクトリ(階層が深い場合は省略表記にする)
prompt_pwd="(${bGREEN}%(5~,%-1~/.../%3~,%~)${RESET})"



# プロンプトの残り文字幅の取得関数
function prompt_count() {
    print -nP '$1' | sed -e $'s/\e\[[0-9;]*m//g' | wc -c
}



# プロンプトの残り文字幅の計算
function expr_prompt_width() {
    if [ $OSTYPE != 'cygwin' ]; then
        prompt_width_left="$(( ${COLUMNS} - $(prompt_count "$prompt_host") ))"
        prompt_width_left="$(( ${prompt_width_left} - $(prompt_count "$prompt_ver") ))"
        ## ↑もっとスマートなやり方を探しておく
        prompt_width_left="$(( ${prompt_width_left} ))"
        prompt_width_left="$(( ${prompt_width_left} - $(prompt_count "$prompt_ifip") ))"
        # ヒストリ数もzsh起動前だとうまく取得できないっぽいので.zsh_historyからおおよその数を取得しておく
        prompt_width_left="$(( ${prompt_width_left} - 4 - $(prompt_count `wc -l ~/.zsh_history | awk '{print $1}'`) ))"
        prompt_width_left="$(( ${prompt_width_left} - 1 ))" #一番右端のスペースを確保しておく

        # 左右で使用できる幅の計算
        if [ $(($prompt_width_left % 2)) -eq 0 ]; then
            #使用できる幅が偶数の場合
            prompt_wl="$(( ${prompt_width_left} / 2 ))"
            prompt_wr="$(( ${prompt_width_left} / 2 ))"
        else
            #使用できる幅が奇数の場合
            prompt_wl="$(( ${prompt_width_left} / 2 ))"
            prompt_wr="$(( ${prompt_width_left} / 2 + 1 ))"
        fi
        # 最終的に使用できる残り幅(Left|Right)
        prompt_bar_l="${bBLACK}${(l:${prompt_wl}::-:)}${RESET}"
        prompt_bar_r="${bBLACK}${(l:${prompt_wr}::-:)}${RESET}"
    fi
}
add-zsh-hook precmd expr_prompt_width




# 通常プロンプト
### viモードを判別してプロンプトに表示
function zle-line-init zle-keymap-select zle-line-finish {
    PROMPT="${prompt_host}${prompt_ver}${prompt_bar_l}${prompt_bar_r}${prompt_ifip}${prompt_hist}"$'\n'"${prompt_user}"

    case $KEYMAP in
        vicmd)
        PROMPT="${PROMPT}:[${bBLUE}Nor${RESET}] ${prompt_ret}${prompt_symbol} "
        ;;
        main|viins)
        PROMPT="${PROMPT}:[${bRED}Ins${RESET}] ${prompt_ret}${prompt_symbol} "
        ;;
    esac

    zle reset-prompt
    ## rootやremote時に入力モードを切り替えると，プロンプトが1行づつ消される原因が分からない
}
zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish



# 右側プロンプト

RPROMPT="${prompt_jobs}${prompt_vcs}${prompt_pwd}"



# 複数行入力時プロンプト "<QUOTENAME> > "
PROMPT2="${bMAGENTA}%_#${RESET} > "

# 入力ミス時プロンプト "<COMMAND> is correct? [n,y,a,e]: "
SPROMPT="${bRED}%r${RESET} is correct? ${YELLOW}[n,y,a,e]${RESET}: "


##バッテリー関連情報の取得
#function battery() {
#if [ -x /usr/bin/acpi ]; then
#    BATTERY_STATUS=`acpi --battery | awk '{print $4}' | awk -F% '{print $1}'`%%\ (`acpi --ac-adapter | awk '{print $3}'`)
#    echo $BATTERY_STATUS
#    #acpi --battery | awk '{print $4}' | awk -F% '{print $1}'
#else
#    BATTERY_STATUS="No Battery"
#fi
#}
##たぶんうまく行かない
##dwmのステータスバーに表示させたほうが良いかもしれない



#CLIの書式の指定
##描写がおかしくなることがあるのでやめとく
#zle_highlight=(default:bold)



#============================================================================
# Completation
#============================================================================

# configureオプション収集を安全にする(補完精度が少し落ちるかも)
configure-fake-help() {
    grep -- '^[ \t]*--[A-Za-z]' ${^words[1]} | egrep -v '\[|\]'
}
zstyle ':completion:*:configure:*:options' \
    command configure-fake-help

# 補完メニュー表示時に'hjkl'で選択 (C^jはIMが優先されるっぽい)
zmodload -i zsh/complist
bindkey -M menuselect \
    'k' up-line-or-history 'j' down-line-or-history \
    'h' backward-char 'l' forward-char #\
#     '^k' up-line-or-history '^j' down-line-or-history \
#     '^h' backward-char '^l' forward-char

# 候補一覧選択を横進みにする(上のhjklがあるから，いらないかも)
# setopt list_rows_first

# '/'を単語とみなさないように記号環境変数から削除
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# 補完機能ON(comsys)
autoload -U compinit
compinit
# 入力中に履歴から予測補完する(重いかも)
# autoload predict-on
# predict-on

# 補完のときに大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 色つき補完をする
eval `dircolors -b`
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# ~,^,#を正規表現として扱う
setopt extended_glob

# 候補が2個以上の場合、補完をメニューから選択する
zstyle ':completion:*' menu select=2

# メニュー補完時に候補をグループ分けする
zstyle ':completion:*' group-name ''
# グループ名を表示する
zstyle ':completion:*:descriptions' format '%B%d%b'

# 補完に色をつける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# TAB1回押しでリスト表示にする
setopt auto_list
# 2回続けてTABでリスト表示にする
# setopt bash_auto_list

# TAB連打でメニュー補完に移行する
setopt auto_menu
# TAB1回押しでメニュー補完に移行する(ちょっと鬱陶しいかも)
# setopt menu_complete

# カーソル位置で補完する
setopt complete_in_word

# 補完時にカーソルを最後尾へ移動する
setopt always_to_end

# ディレクトリ補完時に自動的に付く一番最後のスラッシュを削除する
setopt auto_remove_slash

# グロッピングパターン補完時に結果を即展開しない
setopt glob_complete
# #'cd /etc/ss*/'のとき
# #OFFだと'cd /etc/ssh /etc/ssl'に即展開，ONだと'cd /etc/ss*'の状態で補完リストを表示する

# 補完時にエイリアスを内部で置き換えてオプションを収集しない
unsetopt complete_aliases

# 補完一覧のファイル名の末尾に種別記号をつける
setopt list_types

# typoを修正する
setopt correct



#============================================================================
# Etc
#============================================================================

# ~付き参照後，直ちに名前付きディレクトリとして扱う
setopt auto_name_dirs

# =記号でコマンドフルパス展開をする(=[command]でエイリアスを無視して実行)
setopt equals

# 変数代入時にファイル名を展開する(~/Musicを/home/user/Musicにする)
setopt magic_equal_subst

# マルチリダイレクトON
# #'cat hoge.txt >> foo > bar > piyo'や'cat hoge.txt >> *.tex'みたいに使う
setopt multios

# バックグラウンドで実行したプロセスをジョブテーブルに入れる
setopt monitor

# バックグラウンドジョブの終了をすぐに通知
setopt no_tify

# jobsでプロセスIDを表示
setopt long_list_jobs

# ビープ音を無効
setopt no_beep

# 全ユーザのログイン・ログアウトを監視する
watch="all"
# 誰かがログインした時に表示する
log
# C^Dでログアウトしない
setopt ignore_eof

# 対話シェルでコメントを使用出来るようにする
setopt interactive_comments

# C^S, C^Qのフロー制御を無効
setopt no_flow_control
# no_flow_controlだとVimでは無効にならない(?)ので、XON/XOFFも無効にする
stty -ixon


# 複数ファイルの一括リネーム(zmv)
autoload -Uz zmv
alias zmv='noglob zmv -W'
# # {1..9}.txtがあるときに， "zmv *.txt file_*.txt"のような感じで使う



#============================================================================
# Alias
#============================================================================

case "${OSTYPE}" in
freebsd*)
  alias ls="ls -G -w"
  ;;
linux*|cygwin)
  alias ls="ls -F --color=always"
  ;;
esac
alias ll='ls -l'
alias llk='ls -l --block-size=K'
alias llm='ls -l --block-size=M'
alias la='ls -a'
alias lf='ls -f'
alias lt='ls -alt'
alias lr='ls -R'
alias lal='ls -al'
alias li='ls -i'
alias l='ls -1'
alias lfi='ls -1 | grep -v /'
alias ldi='ls -1 | grep /'

alias grep='grep --color=none'
alias cgrep='grep --color=always'
#alias rm='mv -f --backup=numbered --target-directory ~/.trash'
alias dmesg='dmesg -L'
alias du='du -h'
alias du1='du --max-depth=1'
alias df='df -h'
if [ `whence -p colordiff` ]; then
    alias diff=colordiff
fi

alias d='dirs -lv'
alias pu='pushd'
alias po='popd'
alias less='less -R'
alias lv='lv -c'
alias h='fc -l'
alias cls='clear'
alias j='jobs -l'
alias ed='ed -p :'
alias gcc='gcc -Wall -pedantic'
alias enc='nkf -g'
alias pdf='zathura'
alias info='info  --vi-keys'
alias crontab='crontab -i'
alias halt='halt -p'
alias cal='LANG=c cal'
alias todo='todo.sh'
alias w3m='w3m -v'
alias feh='feh -.'
alias aspell='LANG=c aspell'

alias ruler='echo ----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8----+----9----+----A----+----B----+----C----+----D----+----E----+----F'

alias ci='ci -zLT'
alias co='co -zLT'
alias rlog='rlog -zLT'

if [ $UID -ne 0 ]; then
    alias sudo='sudo ' #sudoに続くコマンドのエイリアスを有効にするため
    alias svim='EDITOR=vim sudoedit'
    alias scat='sudo cat'
fi

if [ `lsb_release --id | cut -f 2` = "Arch" ]; then
    :
elif [ `whence -p nvi` ]; then
    alias vi='nvi'
else
    alias vi='vim -u NONE -C'
fi
alias view='vim -R'

alias py='python'
alias ipy='ipython'
alias bpy='bpython'
alias rb='ruby'

alias dotpush='(cd ~/dotfiles && hg commit -m "Updated." && hg push)'
alias dotpull='(cd ~/dotfiles && hg pull && hg update)'
alias binpush='(cd ~/bin && hg commit -m "Updated." && hg push)'
alias binpull='(cd ~/bin && hg pull && hg update)'

alias pacman='pacman --color=always'

alias pvim='vim -u $HOME/Dropbox/documents/practical_vim/code/essential.vim'

#Mutt
alias mutt='TERM=screen mutt -F $HOME/.mutt/private/muttrc_priv'
alias muttg='TERM=screen mutt -F $HOME/.mutt/private/muttrc_ginjiro'
alias mutto='TERM=screen mutt -F $HOME/.mutt/private/muttrc_ouj'

# LANG
alias eng='LANG=C'
alias jp='LANG=ja_JP.UTF-8'

# alias dirs='dirs -pv' ##aliasしたままだと'-c'が効かなくなるので一時無効

# Global_alias
alias -g ...='../..'
alias -g ....='../../..'
alias -g 4.='../../..'
alias -g .....='../../../..'
alias -g 5.='../../../..'

alias -g L='| $PAGER'

alias -g G='| grep '
alias -g EG='| grep -E '
alias -g H='| head'
alias -g T='| tail'
alias -g TF='| tail -f'
alias -g S='| sort'
alias -g SN='| sort -n'
alias -g U='| uniq'
#alias -g C='| cowsay -n'
alias -g DN='2>/dev/null'
alias -g NG='| nkf --guess'
alias -g NS='| nkf -S'
alias -g NE='| nkf -E'
alias -g NW='| nkf -W'
alias -g LW='| nkf -Lw'
alias -g LU='| nkf -Lu'
alias -g LM='| nkf -Lm'
alias -g NU='| nkf -W -Lu'
# alias -g X='| xcowsay --time=5 --cow-size=small --at=0,0'



# etc
alias sl='sl -e'
alias lock='xscreensaver-command --lock'

# alias impressive='impressive --cache memory --fade --transtime 500 --meshres 12x9'
alias mozcconfig='/usr/lib/mozc/mozc_tool --mode=config_dialog'
alias xrandr_projector='xrandr --output VGA-0 --auto --same-as LVDS'



#============================================================================
# Function
#============================================================================

##オプションが指定されなければ、rmの代わりにmv(ゴミ箱送り)にする
#function rm() {( #関数全体を()でグルーピングして、サブシェルとして動作させる
#    OPT=
#    _COMMAND=
#    _RM_OPT="-"
#    _TARGET=
#
#    if [ $# -eq 1 ]; then
#        _COMMAND="mv -f --backup=numbered --target-directory $HOME/.trash"
#        _TARGET=$1
#    elif [ $# -eq 2 ]; then
#        while getopts dfiIrv OPT
#        do
#            case $OPT in
#                d) _RM_OPT="${_RM_OPT}d" ;; #remove empty dirs
#                f) _RM_OPT="${_RM_OPT}f" ;;
#                i) _RM_OPT="${_RM_OPT}i" ;;
#                I) _RM_OPT="${_RM_OPT}I" ;;
#                r) _RM_OPT="${_RM_OPT}r" ;;
#                v) _RM_OPT="${_RM_OPT}v" ;;
#                *) ;;
#            esac
#        done
#        _COMMAND=/usr/bin/rm
#        _TARGET=$2
#    fi
#
#    #echo "command: $_COMMAND $_RM_OPT $_TARGET"
#    $_COMMAND $_RM_OPT $_TARGET
#)}


# 標準エラー出力を赤色に強調する
function empherr() {(
    exec 3>&1
    "$@" 2>&1 1>&3 | \
        sed -e $'s/^/\e[41m/' -e $'s/$/\e[m/' 1>&2
)}


# CUI PDFビュワー(っぽいの)
function pdfview() { pdftohtml -i $1 -stdout | w3m -T text/html; }


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


#============================================================================
# Named_Directory
#============================================================================

hash -d dropbox=~/Dropbox
hash -d dotfiles=~/Dropbox/dotfiles
hash -d todo=~/Dropbox/todo
hash -d blog=~/Dropbox/documents/blog



#============================================================================
# Startup
#============================================================================

## CUI用
# if [ $TERM = "linux" -a -x /usr/bin/jfbterm ]; then #CUIかつjfbtermが使えるなら起動する
#     jfbterm -q
#     export LANG=ja_JP.UTF-8
#fi

# スタートメッセージ(?)表示
if [ $SHLVL -gt 1 ]; then #シェル深度が1より大きい
    if [ $COLUMNS -gt 100 -a `whence -p fortune` ]; then #$COLUMNSがある程度大きく
        if [ `whence -p cowsay` ]; then #fortuneとcowsayがある場合
            fortune -s | cowsay -n -f dragon-and-cow
        else #fortuneだけの場合
            fortune
        fi
        #区切り線
        echo $'\E'\[01\;30m--------------------------------------------------------------------------------$'\E'\[00m
    fi
    if [ `whence -p cal` ]; then
        LANG=c cal
    fi
fi



#============================================================================
# tmux
#============================================================================

#tmuxで256色表示するための変数設定
export TERM="xterm-256color"

# tmux起動
if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then #rootもしくはリモートホストなら自動で起動しない
elif [ -n "`ps a | grep tmux | grep -v grep`" ] ; then
    tmux attach > /dev/null 2>&1
else
    tmux -2
fi


# zsh+tmuxでsshしたら、新ウィンドウを作成する
if [ -z "${REMOTEHOST}${SSH_CONNECTION}" -a -n "$TMUX" ]; then
    function ssh_tmux() {
    if [ $# -eq 1 ]; then #引数ありなら新ウィンドウは作らない
        eval server=\${$#}
        tmux new-window -n $@ "exec ssh $@"
    else
        ssh $@
    fi
    }
    alias ssh=ssh_tmux

    # zsh+tmuxでmoshしたら、新ウィンドウを作成する
    function mosh_tmux() {
    if [ $# -eq 1 ]; then #引数ありなら新ウィンドウは作らない
        eval server=\${$#}
        tmux new-window -n $@ "exec mosh $@"
    else
        mosh $@
    fi
    }
    alias mosh=mosh_tmux

    # zsh+tmuxでmanしたら、新ウィンドウを作成して開く
    function man_tmux() {
    if [ $# -eq 1 ]; then #引数ありなら新ウィンドウは作らない
        #eval server=\${$#}
        tmux new-window -n "man $@" "exec man $@"
    else
        man $@
    fi
    }
    alias man=man_tmux

    #新ウィンドウではなく、分割ペインで開く
    function sman_tmux() {
    if [ $# -eq 1 ]; then #引数ありなら分割ペインは作らない
        #eval server=\${$#}
        tmux split-window "exec man $@"
    else
        man $@
    fi
    }
    #縦分割ペインで開く
    function vman_tmux() {
    if [ $# -eq 1 ]; then #引数ありなら分割ペインは作らない
        #eval server=\${$#}
        tmux split-window -h "exec man $@"
    else
        man $@
    fi
    }
    alias sman=sman_tmux
    alias vman=vman_tmux
fi



# ターミナルが256色に対応しているか確認する関数
function 256colortest() {
    local code
    for code in {0..255}; do
        echo -e "\E[38;05;${code}m $code: Test"
    done
}



#============================================================================



#============================================================================
# zshでvisualモードっぽいのを使えるようにする
#============================================================================

#######################################################################
#                                                                     #
#               zsh_vim-visualmode for MAC-OSX Ver 1.05               #
#                                                                     #
#     http://zshscreenvimvimpwget.blog27.fc2.com/blog-entry-3.html    #
#                                                                     #
#                          2010/05/13/19:35                           #
#                     created by :%s#hoge#piyo#gc                     #
#                                                                     #
#######################################################################
bindkey -a 'v' vi-v
zle -N vi-v
function vi-v() {
    VI_VIS_MODE=0
    bindkey -a 'v' vi-vis-reset
    bindkey -a '' vi-c-v
    bindkey -a 'V' vi-V
    MARK=$CURSOR
    zle vi-vis-mode
}
#
bindkey -a '' vi-c-v
zle -N vi-c-v
function vi-c-v() {
    VI_VIS_MODE=1
    bindkey -a 'v' vi-v
    bindkey -a '' vi-vis-reset
    bindkey -a 'V' vi-V
    MARK=$CURSOR
    zle vi-vis-mode
}
#
bindkey -a 'V' vi-V
zle -N vi-V
function vi-V() {
    VI_VIS_MODE=2
    bindkey -a 'v' vi-v
    bindkey -a '' vi-c-v
    bindkey -a 'V' vi-vis-reset
    CURSOR_V_START=$CURSOR
    zle vi-end-of-line
    MARK=$(($CURSOR - 1))
    zle vi-digit-or-beginning-of-line
    zle vi-vis-mode
}
#
##########################################################
#
zle -N vi-vis-mode
function vi-vis-mode() {
    zle exchange-point-and-mark
    VI_VIS_CURSOR_MARK=1
#移動系コマンド
    bindkey -a 'f' vi-vis-find
    bindkey -a 'F' vi-vis-Find
    bindkey -a 't' vi-vis-tskip
    bindkey -a 'T' vi-vis-Tskip
    bindkey -a ';' vi-vis-repeatfind
    bindkey -a ',' vi-vis-repeatfindrev
    bindkey -a 'w' vi-vis-word
    bindkey -a 'W' vi-vis-Word
    bindkey -a 'e' vi-vis-end
    bindkey -a 'E' vi-vis-End
    bindkey -a 'b' vi-vis-back
    bindkey -a 'B' vi-vis-Back
    bindkey -a 'h' vi-vis-hidari
    bindkey -a 'l' vi-vis-leftdenai
    bindkey -a '%' vi-vis-percent
    bindkey -a '^' vi-vis-hat
    bindkey -a '0' vi-vis-zero
    bindkey -a '$' vi-vis-doller
#削除、コピーetc
    bindkey -a 'd' vi-vis-delete
    bindkey -a 'D' vi-vis-Delete
    bindkey -a 'x' vi-vis-delete
    bindkey -a 'X' vi-vis-Delete
    bindkey -a 'y' vi-vis-yank
    bindkey -a 'Y' vi-vis-Yank
    bindkey -a 'c' vi-vis-change
    bindkey -a 'C' vi-vis-Change
    bindkey -a 's' vi-vis-change #追加
    bindkey -a 'S' vi-vis-Change #追加
    bindkey -a 'r' vi-vis-change
    bindkey -a 'R' vi-vis-Change
    bindkey -a 'p' vi-vis-paste
    bindkey -a 'P' vi-vis-Paste
    bindkey -a 'o' vi-vis-open
    bindkey -a 'O' vi-vis-open
#インサートへ移行
    bindkey -a 'a' vi-vis-add
    bindkey -a 'A' vi-vis-Add
    bindkey -a 'i' vi-vis-insert
    bindkey -a 'I' vi-vis-Insert
#その他
    bindkey -a 'u' vi-vis-undo
    bindkey -a '.' vi-vis-repeat
    bindkey -a '' vi-vis-reset
    #bindkey -a 's' vi-vis-reset #削除
    #bindkey -a 'S' vi-vis-reset #削除
}
zle -N vi-vis-key-reset
function vi-vis-key-reset() {
    bindkey -M vicmd 'f' vi-find-next-char
    bindkey -M vicmd 'F' vi-find-prev-char
    bindkey -M vicmd 't' vi-find-next-char-skip
    bindkey -M vicmd 'T' vi-find-prev-char-skip
    bindkey -M vicmd ';' vi-repeat-find
    bindkey -M vicmd ',' vi-rev-repeat-find
    bindkey -M vicmd 'w' vi-forward-word
    bindkey -M vicmd 'W' vi-forward-blank-word
    bindkey -M vicmd 'e' vi-forward-word-end
    bindkey -M vicmd 'E' vi-forward-blank-word-end
    bindkey -M vicmd 'b' vi-backward-word
    bindkey -M vicmd 'B' vi-backward-blank-word
    bindkey -M vicmd 'h' vi-h-moto
    bindkey -M vicmd 'l' vi-l-moto
    bindkey -M vicmd '%' vi-match-bracket
    bindkey -M vicmd '^' vi-first-non-blank
    bindkey -M vicmd '0' vi-digit-or-beginning-of-line
    bindkey -M vicmd '$' vi-end-of-line
    bindkey -M vicmd 'd' vi-delete
    bindkey -M vicmd 'D' vi-kill-eol
    bindkey -M vicmd 'x' vi-delete-char  
    bindkey -M vicmd 'X' vi-backward-delete-char
    bindkey -M vicmd 'y' vi-yank
    bindkey -M vicmd 'Y' vi-yank-whole-line
    bindkey -M vicmd 'c' vi-change
    bindkey -M vicmd 'C' vi-change-eol
    bindkey -M vicmd 'r' vi-replace-chars
    bindkey -M vicmd 'R' vi-replace
    bindkey -M vicmd 'p' vi-put-after
    bindkey -M vicmd 'P' vi-put-before
    bindkey -M vicmd 'o' vi-open-line-below
    bindkey -M vicmd 'O' vi-open-line-above
    bindkey -M vicmd 'a' vi-add-next
    bindkey -M vicmd 'A' vi-add-eol
    bindkey -M vicmd 'i' vi-insert
    bindkey -M vicmd 'I' vi-insert-bol
    bindkey -M vicmd 'u' vi-undo-change
    bindkey -M vicmd '.' vi-repeat-change
    bindkey -M vicmd 'v' vi-v
    bindkey -M vicmd '' vi-c-v
    bindkey -M vicmd 'V' vi-V
    bindkey -M vicmd 's' vi-substitute
    bindkey -M vicmd 'S' vi-change-whole-line 
}
#
##########################################################
#
zle -N vi-vis-cursor-shori_before
function vi-vis-cursor-shori_before() {
    if [ $MARK -lt $(( $CURSOR + 1 )) ] ;then
        VI_VIS_CURSOR_MARK=1
    elif [ $MARK -eq $(( $CURSOR + 1 )) ] ;then 
        VI_VIS_CURSOR_MARK=0
    else
        VI_VIS_CURSOR_MARK=-1
    fi
}
#
zle -N vi-vis-cursor-shori_after
function vi-vis-cursor-shori_after() {
    if [ $MARK -lt $(( $CURSOR + 1 )) ] ;then
        if [ ${VI_VIS_CURSOR_MARK} -eq 1 ] ;then
            MARK=$MARK
            CURSOR=$CURSOR
            VI_VIS_CURSOR_MARK=1
        elif [ ${VI_VIS_CURSOR_MARK} -eq 0 ] ;then
            MARK=$(( $MARK - 1 ))
            VI_VIS_CURSOR_MARK=1
        else
            MARK=$(( $MARK - 1 ))
            CURSOR=$CURSOR
            VI_VIS_CURSOR_MARK=1
        fi
    elif [ $MARK -eq $(( $CURSOR + 1 )) ] ;then 
        if [ ${VI_VIS_CURSOR_MARK} -eq 1 ] ;then
            MARK=$(( $MARK + 1 ))
            CURSOR=$CURSOR
            VI_VIS_CURSOR_MARK=-1
        elif [ ${VI_VIS_CURSOR_MARK} -eq 0 ] ;then
            MARK=$MARK
            CURSOR=$CURSOR
            VI_VIS_CURSOR_MARK=-1
        else
            MARK=$(( $MARK - 1 ))
            VI_VIS_CURSOR_MARK=+1
        fi
    else
        if [ ${VI_VIS_CURSOR_MARK} -eq 1 ] ;then
            MARK=$(( $MARK + 1 ))
            CURSOR=$CURSOR
            VI_VIS_CURSOR_MARK=-1
        elif [ ${VI_VIS_CURSOR_MARK} -eq 0 ] ;then
            MARK=$MARK
            CURSOR=$CURSOR
            VI_VIS_CURSOR_MARK=-1

        else
            MARK=$MARK
            CURSOR=$CURSOR
            VI_VIS_CURSOR_MARK=-1
        fi
    fi
}
#
zle -N vi-h-moto
function vi-h-moto() {
    CURSOR=$(( $CURSOR - 1 ))
}
#
zle -N vi-l-moto
function vi-l-moto() {
    CURSOR=$(( $CURSOR + 1 ))
}
#
##########################################################
#
zle -N vi-vis-find
function vi-vis-find() {
    zle vi-vis-cursor-shori_before
    zle vi-find-next-char
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-Find
function vi-vis-Find() {
    zle vi-vis-cursor-shori_before
    zle vi-find-prev-char
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-tskip
function vi-vis-tskip() {
    zle vi-vis-cursor-shori_before
    zle vi-find-next-char-skip
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-Tskip
function vi-vis-Tskip() {
    zle vi-vis-cursor-shori_before
    zle vi-find-prev-char-skip
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-repeatfind
function vi-vis-repeatfind() {
    zle vi-vis-cursor-shori_before
    zle vi-repeat-find
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-repeatfindrev
function vi-vis-repeatfindrev() {
    zle vi-vis-cursor-shori_before
    zle vi-rev-repeat-find
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-word
function vi-vis-word() {
    zle vi-vis-cursor-shori_before
    zle vi-forward-word
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-Word
function vi-vis-Word() {
    zle vi-vis-cursor-shori_before
    zle vi-forward-blank-word
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-end
function vi-vis-end() {
    zle vi-vis-cursor-shori_before
    zle vi-forward-word-end
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-End
function vi-vis-End() {
    zle vi-vis-cursor-shori_before
    zle vi-forward-blank-word-end
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-back
function vi-vis-back() {
    zle vi-vis-cursor-shori_before
    zle vi-backward-word
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-Back
function vi-vis-Back() {
    zle vi-vis-cursor-shori_before
    zle vi-backward-blank-word
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-hidari
function vi-vis-hidari() {
    zle vi-vis-cursor-shori_before
    CURSOR=$(( $CURSOR - 1 ))
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-leftdenai
function vi-vis-leftdenai() {
    zle vi-vis-cursor-shori_before
    CURSOR=$(( $CURSOR + 1 ))
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-percent
function vi-vis-percent() {
    zle vi-vis-cursor-shori_before
    zle vi-match-bracket
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-hat
function vi-vis-hat() {
    zle vi-vis-cursor-shori_before
    zle vi-first-non-blank
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-zero
function vi-vis-zero() {
    zle vi-vis-cursor-shori_before
    zle vi-digit-or-beginning-of-line
    zle vi-vis-cursor-shori_after
}
#
zle -N vi-vis-doller
function vi-vis-doller() {
    zle vi-vis-cursor-shori_before
    zle vi-end-of-line
    zle vi-vis-cursor-shori_after
}
#
##########################################################
#
zle -N vi-vis-delete
function vi-vis-delete() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    CURSOR=$(($CURSOR + 1))
    zle kill-region
}
#
zle -N vi-vis-Delete
function vi-vis-Delete() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    CURSOR=$(($CURSOR + 1))
    zle kill-buffer
}
#
zle -N vi-vis-yank
function vi-vis-yank() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    CURSOR=$(($CURSOR + 1))
    zle kill-region
    zle vi-put-before
}
#
zle -N vi-vis-Yank
function vi-vis-Yank() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    zle vi-yank-whole-line
}
#
zle -N vi-vis-change
function vi-vis-change() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    CURSOR=$(($CURSOR + 1))
    zle kill-region
    zle vi-insert
}
#
zle -N vi-vis-Change
function vi-vis-Change() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    zle kill-buffer
    zle vi-insert
}
#
zle -N vi-vis-paste
function vi-vis-paste() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    zle vi-put-after
}
#
zle -N vi-vis-Paste
function vi-vis-Paste() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    zle vi-put-before
}
#
zle -N vi-vis-open
function vi-vis-open() {
    CURSOR_MARK_TMP=$MARK
    MARK=$(($CURSOR + 1))
    CURSOR=$(( ${CURSOR_MARK_TMP} - 1))
    if [ $MARK -lt $(( $CURSOR + 1 )) ] ;then
        MARK=$(( $MARK - 1 ))
    fi
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR + 1 ))
    fi
}
#
##########################################################
#
zle -N vi-vis-add
function vi-vis-add() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    if [ $CURSOR -lt $MARK ] ;then 
        CURSOR=$(($CURSOR + 1))
    fi
    MARK=$(($CURSOR + 1))
    zle vi-vis-key-reset
    zle vi-add-next
}
#
zle -N vi-vis-Add
function vi-vis-Add() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    zle vi-end-of-line
    MARK=$(($CURSOR + 1))
    zle vi-add-eol
}
#
zle -N vi-vis-insert
function vi-vis-insert() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    if [ $CURSOR -lt $MARK ] ;then 
        CURSOR=$(($CURSOR + 1))
    fi
    MARK=$(($CURSOR + 1))
    zle vi-vis-key-reset
    zle vi-insert
}
#
zle -N vi-vis-Insert
function vi-vis-Insert() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    zle vi-digit-or-beginning-of-line
    MARK=$CURSOR
    zle vi-insert-bol
}
#
##########################################################
#
zle -N vi-vis-undo
function vi-vis-undo() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    zle vi-undo-change
}
#
zle -N vi-vis-repeat
function vi-vis-repeat() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    zle vi-vis-key-reset
    zle vi-repeat-change
}
#
zle -N vi-vis-reset
function vi-vis-reset() {
    if [ $MARK -gt $(( $CURSOR + 1 )) ] ;then
        CURSOR=$(( $CURSOR - 1 ))
    fi
    if [ ${VI_VIS_MODE} -eq 2 ] ;then
        CURSOR=$CURSOR_V_START
    fi
    zle vi-vis-key-reset
    zle vi-cmd-mode
}



