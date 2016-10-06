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

zplug load

LIME_SHOW_HOSTNAME=0
LIME_DIR_DISPLAY_COMPONENTS=3

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

LS_COLORS=$LS_COLORS:'di=1;94'
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

# Alias
alias tn='tmux new-session'
alias ta='tmux attach-session'
alias tls='tmux list-session'
alias py=python
alias py3=python3
