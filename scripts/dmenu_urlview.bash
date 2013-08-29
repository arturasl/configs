#!/bin/bash

while [ "$#" -ne '0' ]; do
	case "$1" in
		--help)
cat <<EOF
$0 [parameters] *file to read urls from*
reads urls from file, summarizes them and present to the user. After user selects
one - opens it in the browser. If file is not specified, reads from *stdin*.
\`--help\`
:	shows this help information.
\`--join-if-begins symbol\`
:	if line begins with specified symbol joins it to previous one
EOF
			exit 0
			;;
		--join-if-begins)
			joinIfBeginsWith="${2:0:1}"
			shift 2
			;;
		*)
			exec <"$1"
			shift 1
			;;
	esac
done

additional='{print}'

# TODO: sanitize input
if [ -n "$joinIfBeginsWith" ]; then
	additional='!f{f=1;prev=$0;next}/^'"${joinIfBeginsWith}"'/{prev=prev substr($0, 2);next}{printf "%s\n%s", prev, $0; prev=""}END{if(prev!="")print prev}'
fi

url=$(
	awk "$additional" |
	grep --only-matching --extended-regexp -e '(https?:\/\/|www\.)(%[0-9a-fA-F]{2}|[-a-zA-Z0-9._~:\/#?&+;=,])*' \
	| dmenu -l 10 -nb '#2E2E2E' -nf '#D6D6D6' -sb '#D6D6D6' -sf '#2E2E2E'
)
[ -n "$url" ] && ~/configs/scripts/showme.bash "$url"
