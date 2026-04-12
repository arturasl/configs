#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail
shopt -s failglob

main() {
    # To see possible mappings:
    #  rofi -show keys -x11 -normal-window

    rofi -modes drun,emoji,calc \
        -show drun \
        -show-icons \
        -case-smart \
        -no-disable-history \
        -theme "Arc-Dark" \
        -kb-accept-entry 'Control+y' \
        \
        -kb-element-next '' \
        -kb-mode-next 'Tab' \
        -kb-element-prev '' \
        -kb-mode-previous 'ISO_Left_Tab' \
        \
        -normal-window \
        -x11
}

main "$@"
