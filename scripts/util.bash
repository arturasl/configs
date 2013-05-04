utilDebugPrint() {
	[ "$argDEBUG" -eq '1' ] && echo -e "[$(date)] $1"
}

utilDebugShowArguments() {
	[ "$argDEBUG" -ne '1' ] && return
	for var in $(eval echo "\\${!arg@}"); do
		utilDebugPrint "${var} = ${!var}"
	done
}

utilSedEscapeReplacement() {
	echo "$1" | sed -e 's/[\/&]/\\&/g'
}

utilShowError() {
	echo "$1" >&2
}

utilCommandExists() {
	which "$1" &>/dev/null
	return "$?"
}

utilGetFileSize () {
	if [ "$1" = '--exact' ]; then
		wc -c < "$2"
	else
		ls -l "$1" | cut -d' ' -f5
	fi
}
