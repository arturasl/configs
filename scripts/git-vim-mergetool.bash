#!/bin/bash

if [ "$#" -ne "4" ] ; then
    echo "Usage: $0 \$base \$local \$remote \$merged"
    exit 1
fi

difftool="vimdiff"
basef="$1"
localf="$2" # TODO: can be empty?
remotef="$3"
mergedf="$4"

"$difftool" "$localf" "$remotef"
diffexitcode="$?"

if [ "$diffexitcode" -eq "0" ] ; then
    mv "$localf" "$mergedf"
else
	exit "$diffexitcode"
fi
