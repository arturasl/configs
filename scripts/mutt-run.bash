#!/bin/bash

if [ -z "$1" ]; then
	settings='gml'
else
	settings="$1"
fi

export MUTT_MAILBOX="${HOME}/Dropbox/configs/mutt/${settings}"
cd ~/Tmp/ && ~/configs/scripts/exec-on-connection.bash --persistent mutt
