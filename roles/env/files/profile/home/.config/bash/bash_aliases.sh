#!/usr/bin/env bash

TRACE_SCRIPT=${TRACE_SCRIPT:+"$TRACE_SCRIPT:"}${BASH_SOURCE}



# enable color support of grep, ls etc. and also add handy aliases
if [[ -x /usr/bin/dircolors ]]
then
    [[ -r ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias  grep='grep --color=auto'
fi

# default options for invoking "ls" command
export LS_OPTIONS="--color=always --classify --time-style=iso"
alias ls='/bin/ls $LS_OPTIONS'
alias  l='ls --almost-all'
alias l.='ls --almost-all --directory .*'
alias ll='l --format=long'
alias lt='ll --time-style=+'
alias lts=$'lt | awk \'{print $1,$3,$4,$6}\''
if command -v exa >/dev/null
then
    alias exa='\exa $LS_OPTIONS'
    alias l-='exa --all --group-directories-first --long'
    alias ll='l- --header --git'
fi
    


[[ $(type splitString 2> /dev/null) == function ]] \
    && alias splitPath='splitString $PATH --delimiter :' \
    || alias splitPath='echo $PATH | tr : \\n'


# Add an "alert" alias for long running commands.  Use like so:  sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


alias tmux='tmux -f ${XDG_CONFIG_HOME}/tmux/tmux.conf'

