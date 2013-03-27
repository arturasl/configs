#!/bin/bash

echo "$1"
have_new=$(echo "$1" | grep 'New:')

if [ -n "$have_new" ]; then
	mails=$(echo "$1" | sed -e 's/.*New:\([[:digit:]]\+\).*/\1/g' ) # number of new messages
	notify-send -u normal -t 10000 'New mail' "New mails: $mails"
fi
