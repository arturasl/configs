#!/bin/bash -xe

cache_file=~/Tmp/irc.cache
irc_file=~/.weechat/highlights.txt

download_file() {
	local fail=0
	local data=
	data="$(ssh -o ConnectTimeout=2 arturas@lapinskas.net \
		"bash -o pipefail -ec 'cut -d: -f1 '${irc_file}' | sort | uniq -c'")" || fail=1
	[ "$fail" -eq 1 ] && return
	echo "$data" > "$cache_file"
}

if [ ! -f "$cache_file" ]; then
	download_file
elif [ "$(stat --format=%Y "$cache_file")" -le "$(( $(date +%s) - 900 ))" ]; then
	download_file
fi

if [ "$1" == '--summarize' ]; then
	echo -n "$(awk 'BEGIN{s=0}{s+=$1}END{print s}' "$cache_file"):0"
else
	cat "$cache_file"
fi
