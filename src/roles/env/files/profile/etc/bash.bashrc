# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# /etc/profile -> /etc/bash.bashrc
# /etc/profile -> /etc/profile.d/*
# cancelled: /etc/profile -> ${XDG_CONFIG_HOME}/bash/bash_profile
# cancelled: ${XDG_CONFIG_HOME}/bash/bash_profile -> ${XDG_CONFIG_HOME}/bash/bashrc
# /etc/profile -> ~/.bash_profile

TRACE_SCRIPT=${TRACE_SCRIPT:+"${TRACE_SCRIPT}:"}${BASH_SOURCE}


# If not running interactively, don't do anything
[[ -z $- ]] && return
[[ $BASH_RC == 'yes' ]] && return


# See bash(1) for more options
# shopt -s globstar                   # If set, the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.
shopt -s histappend                 # append to the history file, don't overwrite it
shopt -s checkwinsize               # check the window size after each command and, if necessary,  update the values of LINES and COLUMNS
HISTCONTROL=ignoreboth              # don't put duplicate lines or lines starting with space in the history.
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT='%F %T '             # record timestamps
PROMPT_COMMAND='history -a'         # save commands in history immediately


# set variable identifying the chroot you work in (used in the prompt below)
[[ -z ${debian_chroot:-} && -r /etc/debian_chroot ]] && debian_chroot=$(cat /etc/debian_chroot)

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# enable bash completion in interactive shells
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# set variable BASH_RC so that not to run this file twice
BASH_RC=yes
