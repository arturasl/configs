function utilDebugPrint() {
	[ "$argDEBUG" -eq '1' ] && echo -e "[$(date)] $1"
}

function utilDebugShowArguments() {
	[ "$argDEBUG" -ne '1' ] && return
	for var in $(eval echo "\\${!arg@}"); do
		utilDebugPrint "${var} = ${!var}"
	done
}

function utilSedEscapeReplacement() {
	echo "$1" | sed -e 's/[\/&]/\\&/g'
}

function utilShowError() {
	echo "$1" >&2
}

function utilCommandExists() {
	which "$1" &>/dev/null
	return "$?"
}
