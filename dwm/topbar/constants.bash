#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
xbmdir="${SCRIPT_DIR}/xbm8x8/"
fg_hi=red
bar_bg_hex='2E2E2E'
bar_fg_hex='BEBEBE'
bar_height=14
dzen_options="-bg #${bar_bg_hex} -fg #${bar_fg_hex} -fn -*-terminus-medium-r-*-*-11-*-*-*-*-*-*-*"
weather_place='vilnius'
