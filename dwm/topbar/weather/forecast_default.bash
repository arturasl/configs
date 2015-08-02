#!/bin/bash -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../constants.bash"

python2 "${SCRIPT_DIR}/forecast.py" \
	--place "$weather_place" \
	--api-key "$(cat "${HOME}/Dropbox/configs/forecast.io.api.key" | tr -d '\n')" \
	--cache-file "${HOME}/Tmp/weather_cache.pickle" \
	$@
