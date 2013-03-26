#!/bin/bash

echo "$1"

function find_mutt {
	# get parent process
	ppid=$(cat /proc/$1/stat | cut -d' ' -f4)
	# get name parent process name and put it to variable only if it contains word mutt
	pmuttname=$(ps -e | awk '$1=='"$ppid"'{print $4}' | grep mutt)

	if [ "$ppid" -eq 1 ]; then # if parent id is 1 we reached init and we can stop
		echo ''
	elif [ -z "$pmuttname" ]; then # if we did not find mutt continue
		find_mutt "$ppid"
	else # we found mutt
		echo "$ppid"
	fi
}

have_new=$(echo "$1" | grep 'New:')

if [ -n "$have_new" ]; then
	mails=$(echo "$1" | sed -e 's/.*New:\([[:digit:]]\+\).*/\1/g' ) # number of new messages
	mutid=$(find_mutt "$$")
	notify-send -u normal -t 10000 'New mail' "$mutid: $mails"
fi
