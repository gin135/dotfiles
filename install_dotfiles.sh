#!/bin/sh

file_list='
    .Xmodmap
    .asoundrc
    .gvimrc
    .hgrc
    .inputrc
    .latexmkrc
    .mkshrc
    .nanorc
    .profile
    .tmux.conf
    .todo.cfg
    .vimrc
    .xinitrc
    .zshenv
    .zshrc
'

dir_list='
    .config/dunst
    .vim
    .mutt
    .w3m
'


dotdir="$HOME/dotfiles/"



for file in $file_list; do
    if [ -L $HOME/$file ]; then
        continue
    elif [ -e $HOME/$file ]; then
        if [ ! -e $HOME/dotfiles_bak ]; then
            mkdir -v -p $HOME/dotfiles_bak/.config
        fi
        #echo "move" $file "to" $HOME/dotfiles_bak/$file
        echo -n "move: "; mv -v $HOME/$file $HOME/dotfiles_bak/$file
    fi
    echo -n "link: "; ln -v -s $dotdir$file $HOME/$file
    #echo $file
done

for dir in $dir_list; do
    if [ -L $HOME/$dir ]; then
        continue
    elif [ -e $HOME/$dir ]; then
        if [ ! -e $HOME/dotfiles_bak ]; then
            mkdir -v -p $HOME/dotfiles_bak/.config
        fi
        #echo "move" $dir "to" $HOME/dotfiles_bak/$dir
        echo -n "move: "; mv -v $HOME/$dir $HOME/dotfiles_bak/$dir
    fi
    if [ ! -e $HOME/.config ]; then
        mkdir -v $HOME/.config
    fi
    echo -n "link: "; ln -v -s $dotdir$dir $HOME/$dir
    #echo $dir
done


chmod +x $dotdir/.xinitrc
