#!/bin/sh

# Source global definitions
if [ -f /etc/zshenv ]; then
    . /etc/zshenv
fi

if [ -f ~/.dotfiles/colors ]; then
    . ~/.dotfiles/colors
fi

settitle() {
    printf "\033k$1\033\\"
}

# User specific aliases and functions
export PATH=$HOME/bin:$HOME/local/bin:$PATH
export LD_LIBRARY_PATH=${HOME}/local/lib/:${LD_LIBRARY_PATH}
export EDITOR=vim
export PAGER=less
export CLICOLOR=1

alias ll='ls -lAFh'
alias grep='grep'
alias du='du -h'
alias df='df -h'
alias tmux='tmux -2'
alias vihosts='sudo vim /etc/hosts'

[[ -f ~/.dotfiles/rich_prompt ]] && . ~/.dotfiles/rich_prompt
