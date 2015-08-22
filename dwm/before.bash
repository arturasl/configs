#!/bin/bash

# fixed https://bugs.launchpad.net/ubuntu/+source/gnome-keyring/+bug/932177
if [ -n "$GNOME_KEYRING_PID" ]; then
    eval $(gnome-keyring-daemon --start)
    export GNOME_KEYRING_CONTROL
    export SSH_AUTH_SOCK
    export GPG_AGENT_INFO
fi
