#!/bin/bash

source "$(dirname "$0")/util.bash"

echo "$1"
have_new=$(echo "$1" | grep 'New:')

if [ -n "$have_new" ]; then
	mails=$(echo "$1" | sed -e 's/.*New:[[:space:]]*\([[:digit:]]*\).*/\1/g' ) # number of new messages
	msg="New mails: $mails"
	title='New mail'
	if [ -x /Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog ]; then
		/Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog bubble --timeout 10 --text "$msg" --title "$title" &
	elif utilCommandExists 'notify-send'; then
		notify-send -u normal -t 10000 "$title" "$msg"
	else
		utilShowError 'Could not show mutt notification'
	fi
fi
