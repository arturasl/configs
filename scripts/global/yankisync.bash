#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail
shopt -s failglob

dir="$1"
[[ ! -d "$dir" ]] \
    && echo "First argument should be a directory with cards. Got: '${dir}'." \
    && exit 1

anki&
ankipid="$!"
sleep 5
npx -- yanki sync ./cards --anki-web
kill -9 "$ankipid"
