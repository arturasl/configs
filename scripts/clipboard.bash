#!/bin/bash

source "$(dirname "$0")/util.bash"

tty=/dev/stdout
# Within tmux use parent tty.
[ -n "$TMUX" ] && tty="$(tmux display-message -p '#{client_tty}')"

if [[ "$1" = '--paste' ]]; then
    if utilCommandExists 'pbpaste' ; then
        pbpaste
    elif utilCommandExists 'xclip' ; then
        xclip -o -selection clipboard
    else
        utilShowError "Could not find program for pasting"
    fi
elif [[ "$1" = '--copy' ]]; then
    printf $'\e]52;c;%s\a' "$(base64 | tr -d '\n')" > "$tty"
else
    utilShowError "Unknown parameter: \"${1}\""
fi
