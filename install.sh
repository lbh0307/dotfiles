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

case "$1" in
  update)
    sudo apt-get update
    sudo apt-get -y dist-upgrade

    # vim
    vim +PlugUpgrade +PlugClean\! +PlugUpdate +qall\!

    sudo apt-get autoremove -y
    ;;

  base)
    sudo sed -i 's/us.archive/kr.archive/g' /etc/apt/sources.list
    sudo apt-get install -y vim zsh tmux
    sudo apt-get install build-essential python-dev python3-dev python3-pip

    # pwndbg
    if [[ ! -e "$HOME/.gdb/pwndbg" ]]; then
      # install gdb
      sudo apt-get install -y gdb
      git clone https://github.com/zachriggle/pwndbg .gdb/pwndbg
      cd $HOME/.gdb/pwndbg
      ./setup.sh
    fi

    # vim plug
    if [ ! -f ~/.vim/autoload/plug.vim ]; then
      curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    # zplug
    if [[ ! -d "$HOME/.zplug" ]]; then
      git clone https://github.com/zplug/zplug "$HOME/.zplug/repos/zplug/zplug"
      ln -s "$HOME/.zplug/repos/zplug/zplug/init.zsh" "$HOME/.zplug/init.zsh"
    fi

    # oh-my-zsh
    if [[ ! -d "$HOME/.zplug/repos/robbyrussell/oh-my-zsh" ]]; then
      git clone https://github.com/robbyrussell/oh-my-zsh "$HOME/.zplug/repos/robbyrussell/oh-my-zsh"
    fi

    # pyenv
    curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
    ;;

  github)
    # setup github
    echo "Type your github account: "
    read GITHUB_ACCOUNT
    ssh-keygen -t rsa -C $GITHUB_ACCOUNT
    eval $(ssh-agent)
    ssh-add $HOME/.ssh/id_rsa
    echo "need to add below public key to github"
    cat $HOME/.ssh/id_rsa.pub
    echo -n "press enter when you done..."
    read t
    ssh -T git@github.com
    ;;

  link)
    install gitignore
    install gitconfig
    install tmux.conf
    install zshrc
    install vimrc
    ;;

  apache)
    # install apache, mysql, php
    sudo apt-get install -y apache2
    echo "apache is running on ....."
    ifconfig eth0 | grep inet | awk '{ print $2 }'

    sudo apt-get install -y mysql-server libapache2-mod-auth-mysql php7.2-mysaql
    sudo mysql_install_db
    sudo /usr/bin/mysql_secure_installation

    sudo apt-get install -y php7.2 libapache2-mod-php7.2 php7.2-mcrypt
    sudo apt-get install -y php7.2-mysql php7.2-sqlite php7.2-common php7.2-dev

    sudo service apache2 restart
    ;;

  *)
    echo "usage: $(basename "$0") <command>"
    echo ''
    echo 'Available commands:'
    echo '    update    Update installed packages'
    echo '    base      Install basic packages'
    echo '    link      Install symbolic links'
    echo '    github    Install github account'
    echo '    apache    Install apache, mysql, php7.2'
esac
