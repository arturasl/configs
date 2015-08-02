#!/bin/bash -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../constants.bash"

width=150
mouse_x="$(xdotool getmouselocation | cut -d ' ' -f1 | cut -d: -f2)"

"${SCRIPT_DIR}/forecast_default.bash" --forecast \
	| dzen2 \
		-y "${bar_height}" -x "$((mouse_x - width / 2))" -w "$width" \
		-l 20 -p \
		$dzen_options \
		-e 'onstart=uncollapse,scrollhome;button1=exit;button3=exit;key_Escape=exit;button4=scrollup;button5=scrolldown'
