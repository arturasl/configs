#!/bin/bash -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/constants.bash"

dwm_bar_width=202
trayer_width=80
conky_bar_width=400
screen_width=$(xrandr | grep '*' | grep -o '[[:digit:]]\+x[[:digit:]]\+' | cut -d'x' -f1)

fnOnFinish() {
	[ -n "$trayer_pid" ] && kill "$trayer_pid"
	[ -n "$playerbar_pid" ] && kill "$playerbar_pid"
	[ -n "$conkybar_pid" ] && kill "$conkybar_pid"
}
trap fnOnFinish EXIT

# trayer
# trayer --edge top --align right --height ${bar_height} --SetDockType true --SetPartialStrut true --expand false --widthtype pixel --width "$trayer_width" --transparent true --alpha 0 --tint "0x${bar_bg_hex}" &
# trayer_pid="$!"

# playerbar
"${SCRIPT_DIR}/playerbar.bash" -h "${bar_height}" -x "${dwm_bar_width}" -w "$((screen_width - trayer_width - conky_bar_width - dwm_bar_width))" $dzen_options &
playerbar_pid="$!"

# conkybar
# "${SCRIPT_DIR}/conkybar.bash" -h "${bar_height}" -x "$((screen_width - trayer_width - conky_bar_width))" -w "${conky_bar_width}" $dzen_options &
# conkybar_pid="$!"

[ -n "$trayer_pid" ] && wait "$trayer_pid"
[ -n "$playerbar_pid" ] && wait "$playerbar_pid"
[ -n "$conkybar_pid" ] && wait "$conkybar_pid"
