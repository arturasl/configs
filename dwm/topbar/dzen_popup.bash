#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/constants.bash"

width=150
mouse_x="$(xdotool getmouselocation | cut -d ' ' -f1 | cut -d: -f2)"

python2 "${SCRIPT_DIR}/weather.py" --place "$weather_place" --api-key "$(cat "${HOME}/Dropbox/configs/forecast.io.api.key" | tr -d '\n')" --cache-file "${HOME}/Tmp/weather_cache.pickle" --forecast \
	| dzen2 \
		-y "${bar_height}" -x "$((mouse_x - width / 2))" -w "$width" \
		-l 20 -p \
		$dzen_options \
		-e 'onstart=uncollapse,scrollhome;button1=exit;button3=exit;key_Escape=exit;button4=scrollup;button5=scrolldown'
