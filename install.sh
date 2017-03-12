#!/bin/bash
DIRNAME="$(dirname "$0")"
DIR="$(cd "$DIRNAME" && pwd)"

install () {
	OLD="$HOME/.$1"
	NEW="$DIR/$1"
	if [ -f $OLD ]; then
		if [ -L $OLD ]; then
			rm $OLD
		else
			mv $OLD "$OLD.bak"
		fi
	fi
	ln -s $NEW $OLD
}

install gitignore
install gitconfig
install tmux.conf
install zshrc
install vimrc

# Vim Plug
if [ ! -f ~/.vim/autoload/plug.vim ]; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
