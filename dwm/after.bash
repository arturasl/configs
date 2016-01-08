#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"${SCRIPT_DIR}/topbar/topbar.bash" &

# run nm-applet (temporally start trayer so that nm would be happy)
trayer &
trayer_pid="$!"
sleep 2
nm-applet &
kill "$trayer_pid"

# start other software
st -e bash -i -c atmux &
firefox &
skype &
dropbox start

# remove dwm version information
xsetroot -name ' '
# set brightness
xbacklight -set 25
place="$("${SCRIPT_DIR}./topbar/weather/forecast_default.bash" --just-place)"
lat="$(echo "$place" | cut -d, -f1 | cut -d: -f2)"
lng="$(echo "$place" | cut -d, -f2 | cut -d: -f2)"
redshift -l "${lat}:${lng}" &
# set wallpaper
feh --bg-scale "$(find ~/Pictures/Wallpapers/ | sort -R | head -n 1)"
# keyboard
setxkbmap -layout us,lt setxkbmap -option grp:alt_shift_toggle
# natural scrolling
synclient VertScrollDelta=-100
synclient HorizScrollDelta=-100
