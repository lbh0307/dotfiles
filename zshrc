# Check if zplug is installed
if [[ ! -d "$HOME/.zplug" ]]; then
  git clone https://github.com/zplug/zplug "$HOME/.zplug/repos/zplug/zplug"
  ln -s "$HOME/.zplug/repos/zplug/zplug/init.zsh" "$HOME/.zplug/init.zsh"
fi

export ZSH=/home/lbh/.zplug/repos/robbyrussell/oh-my-zsh
source $ZSH/oh-my-zsh.sh
source $HOME/.zplug/init.zsh

zplug "zplug/zplug"
zplug "djui/alias-tips"
zplug "yous/lime"
zplug "zsh-users/zsh-syntax-highlighting", nice:9
zplug "zsh-users/zsh-history-substring-search", nice:10

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

LIME_SHOW_HOSTNAME=1
LIME_DIR_DISPLAY_COMPONENTS=3

zplug load

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

LS_COLORS='di=1;94:'
export LS_COLORS
export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM=screen-256color

function add_to_path_once()
{
  if [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

# Set PATH to include user's bin if it exists
if [ -d "$HOME/bin" ]; then
  export PATH = "$HOME/bin:$PATH"
fi

if [ -f "$HOME/.zshrc.local" ]; then
  source $HOME/.zshrc.local
fi

# tmux
alias tn='tmux new-session'
alias ta='tmux attach-session'
alias tls='tmux list-session'

# python
alias py=python
alias py3=python3

# git
alias gs='git status'
alias ga='git add'
alias gap='git add --patch'
alias gc='git commit -v'
alias gps='git push'
alias gpl='git pull'
alias glg='git log --graph --decorate'
alias gd='git diff'

# Vim
alias v='vim'
alias vi='vim'

# http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
function man() {
  env \
    LESS_TERMCAP_mb=$'\e[1;31m' \
    LESS_TERMCAP_md=$'\e[1;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[1;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[1;32m' \
    man "$@"
}

