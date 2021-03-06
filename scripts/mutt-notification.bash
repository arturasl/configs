#!/bin/bash

source "$(dirname "$0")/util.bash"

echo "$1"
have_new=$(echo "$1" | grep 'New:')
settings=$(echo "$1" | sed -e 's/.*Settings:[[:space:]]*\([[:alnum:]]*\).*/\1/g' )

mkdir -p ~/Tmp/mail_stats

if [ -n "$have_new" ]; then
	mails=$(echo "$1" | sed -e 's/.*New:[[:space:]]*\([[:digit:]]*\).*/\1/g' ) # number of new messages
	echo "$mails" > "${HOME}/Tmp/mail_stats/${settings}"

	msg="${settings}: ${mails}"
	title='New mail'
	if [ -x /Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog ]; then
		/Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog bubble --icon document --timeout 10 --text "$msg" --title "$title" &
	elif utilCommandExists 'notify-send'; then
		notify-send -u normal -t 10000 "$title" "$msg"
	else
		utilShowError 'Could not show mutt notification'
	fi
else
	echo '0' > "${HOME}/Tmp/mail_stats/${settings}"
fi
