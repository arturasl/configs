#!/bin/bash

if [ -z "$1" ]; then
	settings='gml'
else
	settings="$1"
fi

export TERM=xterm-256color
export MUTT_MAILBOX="${HOME}/Dropbox/configs/mutt/${settings}"
~/configs/scripts/exec-on-connection.bash mutt
