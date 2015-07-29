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
skype &
firefox &
st -e 'atmux' &

# remove dwm version information
xsetroot -name ' '
