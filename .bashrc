# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f ~/.colours ]; then
    . ~/.colours
fi

settitle() {
    printf "\033k$1\033\\"
}

# User specific aliases and functions
export PATH=$HOME/bin:$HOME/local/bin:$PATH
export LD_LIBRARY_PATH=${HOME}/local/lib/:${LD_LIBRARY_PATH}
export EDITOR=vim
export PAGER=less

alias su='su -m'
alias lsmig='ls bin/migration/ | awk '"'"'{print "bin/migration/" $0}'"'"
alias restn="sudo /usr/local/nginx/sbin/nginx -t && sudo /usr/bin/killall -1 nginx"
alias bashrc='. ~/.bashrc'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'
alias du='du -h'
alias df='df -h'
alias tmux='tmux -2'
# alias vim='vim -p'

alias games_starman="starman --group games -I${HOME}/back-games.my.com/lib --listen /var/run/starman/${USER}.sock ${HOME}/back-games.my.com/psgi-bin/gmc.psgi"

umask 0002

# Predictable SSH authentication socket location.
SOCK="/tmp/ssh-agent-$USER-tmux"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
    ln -sf $SSH_AUTH_SOCK $SOCK
    export SSH_AUTH_SOCK=$SOCK
fi

export LANG='ru_RU.UTF-8'
export LC_MESSAGES='ru_RU.UTF-8'
export LC_CTYPE='ru_RU.UTF-8'
export LC_COLLATE='ru_RU.UTF-8'
export LC_ALL='ru_RU.UTF-8'
export PATH_PRJ=/home/sites/s.morozov.games.gm1.corp.mail.ru/.www

# Dreadatour
function parse_git_status {
    # clear git variables
    GIT_BRANCH=
    GIT_DIRTY=

    # exit if no git found in system
    local GIT_BIN=$(which git 2>/dev/null)
    [[ -z $GIT_BIN ]] && return

    # check we are in git repo
    local CUR_DIR=$PWD
    while [ ! -d ${CUR_DIR}/.git ] && [ ! $CUR_DIR = "/" ]; do CUR_DIR=${CUR_DIR%/*}; done
    [[ ! -d ${CUR_DIR}/.git ]] && return

    # 'git repo for dotfiles' fix: show git status only in home dir and other git repos
    [[ $CUR_DIR == $HOME ]] && [[ $PWD != $HOME ]] && return

    # get git branch
    GIT_BRANCH=$($GIT_BIN symbolic-ref HEAD 2>/dev/null)
    [[ -z $GIT_BRANCH ]] && return
    GIT_BRANCH=${GIT_BRANCH#refs/heads/}

    # get git status
    local GIT_STATUS=$($GIT_BIN status --porcelain 2>/dev/null)
    [[ -n $GIT_STATUS ]] && GIT_DIRTY=true
}

function prompt_command {
    local PS1_GIT=
    local PWDNAME=$PWD

    # get cursor position and add new line if we're not in first column
#    exec < /dev/tty
#    local OLDSTTY=$(stty -g)
#    stty raw -echo min 0
#    echo -en "\033[6n" > /dev/tty && read -sdR CURPOS
#    stty $OLDSTTY
#
#    echo -en "\033[6n" && read -sdR CURPOS
#    [[ ${CURPOS##*;} -gt 1 ]] && echo "${color_error}↵${color_error_off}"


    # beautify working directory name
    if [ $HOME == $PWD ]; then
        PWDNAME="~"
    elif [ $HOME ==  ${PWD:0:${#HOME}} ]; then
        PWDNAME="~${PWD:${#HOME}}"
    fi
 
    # parse git status and get git variables
    parse_git_status
 
    # build b/w prompt for git
    [[ ! -z $GIT_BRANCH ]] && PS1_GIT="git: ${GIT_BRANCH}"

    PS1_ENV=
    if [ ! -z $WORK_ENV ]; then
        PS1_ENV="env: ${WORK_ENV} "
    fi

    # set b/w prompt
    PS1="${USER}@${HOSTNAME}:${PWDNAME} (${PS1_ENV}${PS1_GIT})"
 
    local color_user=
    if $color_is_on; then
        # set user color
        case `id -u` in
            0) color_user=$color_red ;;
            *) color_user=$color_green ;;
        esac

        if [ ! -z $WORK_ENV ]; then
            PS1_ENV="env: ${ENV_COLOR}${WORK_ENV}${color_off} "
        fi
 
        # build git status for prompt
        if [ ! -z $GIT_BRANCH ]; then
            if [ -z $GIT_DIRTY ]; then
                PS1_GIT="git: ${color_green}${GIT_BRANCH}${color_off}"
            else
                PS1_GIT="git: ${color_red}${GIT_BRANCH}${color_off}"
            fi
        fi
    fi

    # calculate fillsize
    local fillsize=$(($COLUMNS-$(printf "${PS1} " | wc -c | tr -d " ") - 9))

    local FILL=''
    while [ $fillsize -gt 0 ]; do FILL="${FILL}─"; fillsize=$(($fillsize-1)); done

    # set new color prompt
    PS1="${color_user}${USER}${color_off}@${color_yellow}${HOSTNAME}${color_off}:${color_white}${PWDNAME}${color_off} (${PS1_ENV}${PS1_GIT}) ${FILL} $(date +%H:%M:%S)\n➜ "

    # echo -en "$(printf -v f "%$((${COLUMNS} - 9))s" ; printf "%s\n" "${f// /─}") $(date +%H:%M:%S)\r"
}
PROMPT_COMMAND=prompt_command
# /Dreadatour

. /etc/bash_completion.d/*
