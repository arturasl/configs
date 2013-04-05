#!/bin/bash

source "$(dirname "$0")/util.bash"

if [ "$1" = '--paste' ]; then
	if utilCommandExists 'pbpaste' ; then
		pbpaste
	elif utilCommandExists 'xclip' ; then
		xclip -o -selection clipboard
	else
		utilShowError "Could not find program for pasting"
	fi
elif [ "$1" = '--copy' ]; then
	if utilCommandExists 'pbcopy' ; then
		pbcopy
	elif utilCommandExists 'xclip' ; then
		xclip -i -selection clipboard
	else
		utilShowError "Could not find program for pasting"
	fi
else
	utilShowError "Unknown parameter: \"${1}\""
fi
