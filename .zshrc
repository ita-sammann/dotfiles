# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

PATH="$HOME/bin:$HOME/local/bin"
PATH="$PATH:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin"
PATH="$PATH:/usr/local/python2.7/bin" # custom python
PATH="$PATH:/usr/local/go/bin" # golang binaries path
PATH="$PATH:$HOME/go/bin" # go bin path
PATH="$PATH:$HOME/code/go/bin" # custom go bin path
export PATH
export MANPATH="/usr/local/man:$MANPATH"
export LD_LIBRARY_PATH=${HOME}/local/lib/:${LD_LIBRARY_PATH}
export EDITOR=vim
export PAGER=less


# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="mygnoster"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
#COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(perl git docker kubectl)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Predictable SSH authentication socket location.
SOCK="/tmp/ssh-agent-$USER-tmux"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
    ln -sf $SSH_AUTH_SOCK $SOCK
    export SSH_AUTH_SOCK=$SOCK
fi

PROMPT_EOL_MARK="%F{white}%K{red}↩ %F%K"

source ~/.iterm2_shell_integration.zsh
source ~/.fzf.zsh
source ~/.zsh-autoenv/autoenv.zsh

alias su='su -m'
alias bashrc='. ~/.bashrc'
alias zshrc='. ~/.zshrc'
alias ll='ls -laFh --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias du='du -h'
alias df='df -h'
alias psgr='ps aux | head -1; ps aux | ag '
#alias tmux='tmux -2'
alias su='sudo -E su -m'
alias agl='ag --pager "less -F"'


umask 0002

#export CDPATH=~:.:~/git

export LANG='en_US.UTF-8'
export LC_MESSAGES='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LC_COLLATE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

export GOPATH=$HOME/code/go

# Virtualenv
export VIRTUAL_ENV_DISABLE_PROMPT=1

DIR=$HOME/.gmr
test -f $DIR/dir_colors && eval `dircolors $DIR/dir_colors`

#alias prj="ls ~/git | fzf | xargs -I{} tmux send-keys 'cd ~/git/'{} 'C-m'"
alias prj="cd \`cat ~/.projects | fzf | awk '{ print \$(NF) }' | sed 's|~|$HOME|'\`"
alias ssadd="comm -23 <(find ~/.ssh -type f -name '*.pub' | perl -pe 's/\.pub\$//' | sort -u) <(ssh-add -l | awk '{ print \$3 }' | sort -u) | perl -pe 's!^.*/!!' | fzf | xargs -I{} ssh-add -K ~/.ssh/{}"

# Direnv
eval "$(direnv hook zsh)"
