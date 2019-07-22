#!/bin/bash

check_host='www.google.com'
max_attempts=-1
timeout=30
debug=1
persistent=0

while :; do
	case "$1" in
		--help)
echo "$0 [parameters] unquoted command to execute"
cat <<EOF
Runs given command if specified host is reachable.
Possible parameters:
--check-host host
	address of host to which this script will try to connect
--max-attemts num
	maximum number of connection attempts to make (after exhausting this number this script will exit with status 1). Use negative value as infinity.
--persistent
reopens program if it closes (honors --max-attemts)
--timeout num
	number of seconds to wait between consequent connection attempts
--debug 1
	if this flag is set to one, this script will output some debuging information to stderr
EOF
echo "Example usage $0 --check-host www.google.com --timeout 1 --debug 1 --max-attempts 1 echo 'connected!' || echo 'could not connect'"
			exit 0
			;;
		--check-host)
			check_host="$2" && shift 1
			;;
		--max-attempts)
			max_attempts="$2" && shift 1
			;;
		--timeout)
			timeout="$2" && shift 1
			;;
		--persistent)
			persistent=1
			;;
		--debug)
			debug="$2" && shift 1
			;;
		*)
			break
			;;
	esac
	shift 1
done

[ "$debug" -eq "1" ] && echo "check_host = ${check_host}, max_attempts = ${max_attempts}, timeout = ${timeout}, command = $@" 1>&2

i=0
while [ "$i" -ne "$max_attempts" ]; do
	if ( host "$check_host" && ping -c 1 "$check_host" ) &>/dev/null; then
		if [ "$persistent" -eq 1 ]; then
			"$@"
		else
			exec "$@"
		fi
	fi
	[ "$debug" -eq "1" ] && echo "[$(date)] Could not connect to ${check_host} or given command quit" 1>&2
	sleep "$timeout"
	((i++))
done 2> >(awk "{print \"$0: \"\$0}" | logger --stderr)

exit 1
