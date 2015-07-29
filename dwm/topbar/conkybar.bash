#!/bin/bash -xe

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/constants.bash"

conky_cpu=0
conky_mem=1
conky_temp=2
conky_down=3
conky_up=4
conky_bat=5

makeImgVal() {
	echo -n "^i(${xbmdir}/${1}.xbm)"
}

makeConkyVal() {
	conky_index="$1"
	maxval=$( ( [ -n "$2" ] && echo "$2" ) || echo 0)
	minval=$( ( [ -n "$3" ] && echo "$3" ) || echo 0)
	img="$4"
	val="${conky_arr[${conky_index}]}"
	val=$( ( [ -n "$val" ] && echo "$val" ) || echo 0)
	intval="$(echo $val | cut -d'.' -f1)"

	if [ \( "$maxval" -ne "0" -a "$intval" -gt "$maxval" \) -o \( "$minval" -ne "0" -a "$intval" -lt "$minval" \) ]; then
		echo -n "^fg(${fg_hi})"
	fi

	if [ -n "$img" ]; then
		makeImgVal "$img"
		echo -n ' '
	fi

	echo -n "$val"
}

while true; do
	OLDIFS="$IFS"; IFS='|'; conky_arr=($(conky 2>/dev/null)); IFS="$OLDIFS"
	title=""
	title+="$(makeImgVal mail)"
	title+=" $(makeConkyVal ${conky_bat} '' 10 bat_full_02)%^fg()"
	title+=" $(makeConkyVal ${conky_cpu} 95 '' cpu)%^fg()"
	title+=" $(makeConkyVal ${conky_mem} 95 '' mem)%^fg()"
	title+=" $(makeConkyVal ${conky_temp} '' '' temp)°^fg()"
	title+=" $(makeConkyVal ${conky_down} '' '' net_down_03)^fg()"
	title+=" $(makeConkyVal ${conky_up} '' '' net_up_03)^fg()"
	title+="     $(makeImgVal clock) $(date '+%H:%M %Y-%m-%d')"

	echo "$title"
	sleep 5
done > >(dzen2 $@)
