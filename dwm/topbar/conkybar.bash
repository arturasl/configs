#!/bin/bash -xe

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/constants.bash"

conky_cpu=0
conky_mem=1
conky_temp=2
conky_down=3
conky_up=4
conky_bat=5
conky_wireless=6
conky_fs_used=7

makeImgVal() {
	echo -n "^i(${xbmdir}/${1}.xbm)"
}

makeConkyVal() {
	val="$1"
	maxval=$( ( [ -n "$2" ] && echo "$2" ) || echo -1)
	minval=$( ( [ -n "$3" ] && echo "$3" ) || echo -1)
	img="$4"
	postfix="$5"
	val=$( ( [ -n "$val" ] && echo "$val" ) || echo 0)
	intval="$(echo $val | cut -d'.' -f1)"

	if [[ ! "$intval" =~ [[:digit:]]+ ]]; then
		return
	fi

	echo -n ' '

	if [ \( "$maxval" -ne "-1" -a "$intval" -gt "$maxval" \) -o \( "$minval" -ne "-1" -a "$intval" -lt "$minval" \) ]; then
		echo -n "^fg(${fg_hi})"
	fi

	if [ -n "$img" ]; then
		makeImgVal "$img"
		echo -n ' '
	fi

	echo -n "${val}${postfix}^fg()"
}

while read -r conky_line; do
	title=""

	# weather
	title+="^ca(1, '${SCRIPT_DIR}/dzen_popup.bash')"
	title+="$(python2 "${SCRIPT_DIR}/weather.py" --place "$weather_place" --api-key "$(cat "${HOME}/Dropbox/configs/forecast.io.api.key" | tr -d '\n')" --cache-file "${HOME}/Tmp/weather_cache.pickle")"
	title+="^ca()"

	# mail
	total_mails=0
	if [ -d ~/Tmp/mail_stats ]; then
		for f in ~/Tmp/mail_stats/*; do
			cur="$(cat "$f")"
			total_mails=$(( total_mails + cur ))
		done

		if [ "$total_mails" -ne 0 ]; then
			title+="$(makeConkyVal "$total_mails" 0 '' mail '')"
		fi
	fi

	# conky
	OLDIFS="$IFS"; IFS='|'; conky_arr=($conky_line); IFS="$OLDIFS"
	title+="$(makeConkyVal "${conky_arr[${conky_bat}]}" '' 10 bat_full_02 '%')"
	title+="$(makeConkyVal "${conky_arr[${conky_cpu}]}" 95 '' cpu '%')"
	title+="$(makeConkyVal "${conky_arr[${conky_mem}]}" 95 '' mem '%')"
	title+="$(makeConkyVal "${conky_arr[${conky_fs_used}]}" 95 '' diskette '%')"
	title+="$(makeConkyVal "${conky_arr[${conky_temp}]}" 50 '' temp '°')"
	title+="$(makeConkyVal "${conky_arr[${conky_down}]}" '' '' net_down_03 '')"
	title+="$(makeConkyVal "${conky_arr[${conky_up}]}" '' '' net_up_03 '')"
	title+="$(makeConkyVal "${conky_arr[${conky_wireless}]}" '' 5 dish '%')"

	# time
	title+="   $(makeImgVal clock) $(date '+%H:%M %Y-%m-%d')"

	echo "$title"
done > >(dzen2 $@) < <(conky "--config=${SCRIPT_DIR}/conky.rc")
