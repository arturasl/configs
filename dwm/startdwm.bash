#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

finish() {
	kill -TERM 0 && wait && exit 0
}
trap finish EXIT

{
	source "${SCRIPT_DIR}/before.bash"
	dwm &
	wm="$!"
	source "${SCRIPT_DIR}/after.bash"
	wait "$wm"
	sleep 2
} 2>&1 1>/dev/null | grep -v '^+' | awk '{print "dwm: "$0}' | logger
