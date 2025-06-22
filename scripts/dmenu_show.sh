#!/bin/bash

rofi -modes drun -show drun \
    -show-icons \
    -matching fuzzy \
    -case-smart \
    -normal-window \
    -no-disable-history \
    -theme purple \
    -kb-accept-entry 'Control+y' \
    -kb-mode-next 'Tab' \
    -kb-element-next ''
