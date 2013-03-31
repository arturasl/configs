#!/bin/bash
# author: Artūras Lapinskas

source "$(dirname "$0")/util.bash"

function capWebBrowser() {
	( program='/Applications/Firefox.app' && [ $(which open) -a -d "$program" ] && echo "open -a '${program}'" ) \
	|| ( program='firefox' && [ $(which $program ) ] && echo "$program" )
}

function capPDFViewer() {
	( program='/Applications/Preview.app' && [ $(which open) -a -d "$program" ] && echo "open -a '${program}'" ) \
	|| ( program='evince' && [ $(which "$viewe"r ) ] && echo "$program" )
}

# regex for file name \t regex for mime type \t command for viewing gui \t command for viewing as text stream \t priority
read -r -d '' capabilities <<EOF
^http://|^ftp://|\.html?$	text/html	capWebBrowser	pandoc -f html -t markdown	50
\.mp[3-4]$|\.flv	video/.+|audio/.+	mplayer	file	50
\.pdf	application/pdf	capPDFViewer	pdftotext FILENAME -	50
EOF

FIELD_NAME_PATTERN=1
FIELD_MIME_PATTERN=2
FIELD_VIEW_GUI=3
FIELD_VIEW_TEXT_STREAM=4
FIELD_PRIORITY=5

# fill up arguments

argDEBUG='0'
argSilentDetached='0'
argOnlyCheck='0'
argFileName=''
argFileMime=''
argCheckFile='1'
argCheckMime='0'
argFieldToExec="$FIELD_VIEW_GUI"

while [ "$#" -ne '0' ]; do
	case "$1" in
		--help)
echo "$0 [parameters] *name of file to view*"
cat <<EOF
\`--help\`
:	shows this help information.

\`--silent-detached\`
:	runs viewer in such way that initial parent would not be stopped
	and no output in it would be shown.

\`--view-gui\`
:	indicates that gui programs can be used (on by default, but can be
	overriden by other \`--view-*\` parameters).

\`--view-text-stream\`
:	previews given file as text output (you should possibly consider
	piping output to some pager).

\`--only-check\`
:	does not run preview, just checks if there is an applicable one.
	Exit status of *0* means that given file can be previewed.

\`--check-file\` *0 or 1*
:	indicates if preview program should be deduced by using given file
	name (on by default).

\`--check-mime\` *0 or 1*
:	indicates if preview program should be deduced by using mime type
	of given file. If mime type is not given explicitly, this script
	will run \`file\` program to deduce one.

\`--mime\` *mime type*
:	explicetly set mime type to use (also sets \`--check-mime\` to *1*).

\`--debug\`
:	if present additional debuging information will be shown

EOF
echo "Example usage: $0 --view-gui --silent-detached test.pdf"
			exit 0
			;;
		--silent-detached)
			argSilentDetached='1' && shift 1
			;;
		--view-gui)
			argFieldToExec="$FIELD_VIEW_GUI" && shift 1
			;;
		--view-text-stream)
			argFieldToExec="$FIELD_VIEW_TEXT_STREAM" && shift 1
			;;
		--only-check)
			argOnlyCheck='1' && shift 1
			;;
		--check-file)
			argCheckFile="$2" && shift 2
			;;
		--check-mime)
			argCheckMime="$2" && shift 2
			;;
		--mime)
			argFileMime="$2" && shift 2
			argCheckMime='1'
			;;
		--debug)
			argDEBUG="1" && shift 1
			;;
		*)
			argFileName="$1" && shift 1
			;;
	esac
done

# user requested to check mime, but did not provide one
[ "$argCheckMime" -eq '1' -a -z "$argFileMime" ] && argFileMime=$(file --brief --mime-type "$argFileName")

utilDebugShowArguments
utilDebugPrint "Capabilities:\n${capabilities}\n"

# fill up applicable array (with entries of form "priority\texecutable")
OLDIFS="$IFS"
IFS=$'\n'
applicable=''
for capability in $capabilities; do
	patternForName=$(echo "$capability" | cut -f "$FIELD_NAME_PATTERN")
	patternForMime=$(echo "$capability" | cut -f "$FIELD_MIME_PATTERN")

	if [[ ( "$argCheckFile" -eq '1' && "$argFileName" =~ $patternForName ) || ( "$argCheckMime" -eq '1' && "$argFileMime" =~ $patternForMime ) ]]; then
		execute=$(echo "$capability" | cut -f "$argFieldToExec")
		priority=$(echo "$capability" | cut -f "$FIELD_PRIORITY")

		# if execute contain internal function - call it
		executeType=$(type --type "$execute")
		if [ "$?" -a "$executeType" = "function" ]; then
			utilDebugPrint "Trying to apply internal function: ${execute}"
			execute=$("$execute")
			utilDebugPrint "Result = ${execute}"
		fi

		# if execute non empty (might be empty if we called internal function) add it (with priority) to applicable array
		if [ -n "$execute" ]; then
			[ -n "$applicable" ] && applicable="$applicable"$'\n' # do not append new line character for first entry
			applicable="${applicable}${priority}"$'\t'"$execute"
		fi
	fi
done
IFS="$OLDIFS"

# take executable with highest priority
applicable=$(echo "${applicable}" | sort --numeric-sort --reverse)
utilDebugPrint "Applicable:\n${applicable}"
execute=$(echo "${applicable}" | head -n 1 | cut -f 2)

# check if we managed to find executable
if [ -z "$execute" ]; then
	utilDebugPrint "Could not find/run executable"
	exit 1
fi

# append argument (or replace FILENAME) and run executable
execute=$( ( [[ "$execute" =~ FILENAME ]] && echo "$execute" | sed -e "s/FILENAME/'"$(utilSedEscapeReplacement "$argFileName")"'/g" ) || echo "${execute} '${argFileName}'" )
[ "$argSilentDetached" -eq '1' ] && execute="bash -c \"${execute} &>/dev/null &\""
utilDebugPrint "Will execute: ${execute}"
if [ "$argOnlyCheck" -eq '1' ]; then
	exit 0
else
	eval "exec ${execute}"
fi