#!/bin/bash
# author: Artūras Lapinskas

source "$(dirname "$0")/util.bash"

wh() {
	which "$1" &>/dev/null
}

capWebBrowser() {
	{ program='/Applications/Firefox.app' && wh open && [[ -d "$program" ]] && echo "open -a '${program}'"; } \
	|| { program='chromium' && utilCommandExists "$program" && echo "$program"; } \
	|| { program='firefox' && utilCommandExists "$program" && echo "$program"; }
}

capPDFViewer() {
	{ program='/Applications/Skim.app' && wh open && [[ -d "$program" ]] && echo "open -a '${program}'"; } \
	|| { program='/Applications/Preview.app' && wh open && [[ -d "$program" ]] && echo "open -a '${program}'"; } \
	|| {
		file="$1"
		program='zathura'
		if utilCommandExists "$program"; then
            if ! ps --user "$(id -u)" --format "command" \
                | grep --fixed-strings --ignore-case --line-regexp "${program} ${file}" &>/dev/null; then
				echo "$program"
			else
				echo 'echo'
			fi
		fi
	} \
	|| { program='evince' && utilCommandExists "$program" && echo "$program"; }
}

capWordViewer() {
	{ program='/Applications/LibreOffice.app' && wh open && [[ -d "$program" ]] && echo "open -a '${program}'"; } \
	|| { program='libreoffice' && utilCommandExists "$program" && echo "$program"; }
}

capGUIEditor() {
	{ program='mvim' && utilCommandExists "$program"; } \
	|| { program='gvim' && utilCommandExists "$program"; } \
	|| program=''

	[[ -z "$program" ]] && return

	if [[ -t 0 ]]; then # stdin is availabe
		echo "$program -v"
	else
		echo "$program"
	fi
}

capCat() {
	if [[ "$(pygmentize -N "$1")" != 'text' ]];then
		echo bash -c '"pygmentize -P style=dracula FILENAME | expand --tabs=2 --initial | cat -n"'
	else
		echo cat
	fi
}

capVideoInfo() {
	{ program='mediainfo' && utilCommandExists "$program" && echo "$program"; } \
	|| { program='file' && utilCommandExists "$program" && echo "$program"; }
}

capVideo() {
	{ program='mpv' && utilCommandExists "$program" && echo "$program"; } \
	|| { program='mplayer' && utilCommandExists "$program" && echo "$program"; }
}

# regex for file name \t regex for mime type \t command for viewing gui \t command for viewing as text stream \t priority
read -r -d '' capabilities <<EOF
^https?://|^ftps?://|\.html?$|^www\.	text/html	capWebBrowser	pandoc -f html -t markdown	50
\.(mp[3-4]|m4v|flv|mov|avi|ogv|wmv|mkv|3gp|webm)$	video/.+|audio/.+	capVideo	capVideoInfo	50
\.(pdf|eps|ps)$	application/pdf	capPDFViewer	pdftotext FILENAME -	50
\.(jpe?g|png|gif)$	image/.+	feh --draw-actions	img2txt	50
\.docx$			docx2txt FILENAME -	75
\.doc$			antiword	75
\.odt$			odt2txt	75
\.(docx?|odt|ods|xlsx?)$	application/(vnd.openxml.*|.*excel.*|.*oasis.*)	capWordViewer		50
\.uxf$		umlet		50
\.zip$	application/zip		unzip -l	50
\.rar$		unrar l	unrar l	50
\.tar$	application/x-tar	tar -tvf	tar -tvf	50
\.tar.gz$	multipart/x-gzip	tar -tzvf	tar -tzvf	50
\.tar.bz2$		tar -tjvf	tar -tjvf	50
\.so$	application/x-sharedlib		bash -c "ldd FILENAME && objdump -TC FILENAME"	50
	application/x-executable		objdump -f	50
\.o$	application/x-object		objdump -tC	50
	inode/directory		ls -lah	50
.	.	capGUIEditor	capCat	25
EOF

FIELD_NAME_PATTERN=1
FIELD_MIME_PATTERN=2
FIELD_VIEW_GUI=3
FIELD_VIEW_TEXT_STREAM=4
FIELD_PRIORITY=5

# fill up arguments

argSilentDetached='0'
argOnlyCheck='0'
argFileName=''
argFileMime=''
argCheckFile='1'
argCheckMime='0'
argFieldToExec="$FIELD_VIEW_GUI"
argDEBUG='0'
argOpenCopy='0'
argOpenMoved='0'

while [[ "$#" -ne '0' ]]; do
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

\`--open-copy\`
:	if present copies original file to tmp directory and opens generated
	copy

\`--open-moved\`
:	similar to \`open-copy\`, but moves file instead of copying

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
			if [[ ! "$2" =~ \/unknown ]]; then
				argFileMime="$2"
			fi
			shift 2
			argCheckMime='1'
			;;
		--debug)
			argDEBUG='1' && shift 1
			;;
		--open-copy)
			argOpenCopy='1' && shift 1
			;;
		--open-moved)
			argOpenMoved='1' && shift 1
			;;
		*)
			[[ -n "$argFileName" ]] && utilShowError "File specified multiple time (old value = \"${argFileName}\", new value = \"${1}\")"
			argFileName="$1" && shift 1
			;;
	esac
done

# user requested to check mime, but did not provide one
[[ "$argCheckMime" -eq 1 && -z "$argFileMime" ]] && argFileMime="$(file --brief --mime-type "$argFileName")"

utilDebugShowArguments
utilDebugPrint "Will check against file name: ${argFileName}"
utilDebugPrint "Will check against mime type: ${argFileMime}"
utilDebugPrint "Capabilities:\n${capabilities}\n"

# fill up applicable array (with entries of form "priority\texecutable")
OLDIFS="$IFS"
IFS=$'\n'
applicable=''
for capability in $capabilities; do
	patternForName=$(echo "$capability" | cut -f "$FIELD_NAME_PATTERN")
	patternForMime=$(echo "$capability" | cut -f "$FIELD_MIME_PATTERN")

	if [[
		( "$argCheckFile" -eq 1 && -n "$patternForName" && "$argFileName" =~ $patternForName )
		|| ( "$argCheckMime" -eq 1 && -n "$patternForMime" && "$argFileMime" =~ $patternForMime )
	]]; then
		execute=$(echo "$capability" | cut -f "$argFieldToExec")
		priority=$(echo "$capability" | cut -f "$FIELD_PRIORITY")

		# if execute contain internal function - call it
		executeType=$(type --type "$execute")
		if [[ "$?" -eq 0 && "$executeType" = "function" ]]; then
			utilDebugPrint "Trying to apply internal function: ${execute}"
			execute=$("$execute" "$argFileName" "$argFileMime")
			utilDebugPrint "Result = ${execute}"
		fi

		# if execute non empty (might be empty if we called internal function) add it (with priority) to applicable array
		if [[ -n "$execute" ]]; then
			[[ -n "$applicable" ]] && applicable="$applicable"$'\n' # do not append new line character for first entry
			applicable="${applicable}${priority}"$'\t'"$execute"
		fi
	fi
done
IFS="$OLDIFS"

# take executable with highest priority and put to `execute`
applicable=$(echo "${applicable}" | sort --numeric-sort --reverse)
utilDebugPrint "Applicable:\n${applicable}"
execute=$(echo "${applicable}" | head -n 1 | cut -f 2)

# check if we managed to find executable
if [[ -z "$execute" ]]; then
	utilShowError "Could not find/run executable"
	exit 1
fi

if [[ "$argOpenCopy" -eq 1 || "$argOpenMoved" -eq 1 ]]; then
	tmpFile="/tmp/showme-$((RANDOM))-$(basename "$argFileName")"
	tmpFileMoveAction=$( ( [[ "$argOpenCopy" -eq '1' ]] && echo 'cp' ) || echo 'mv' )
	utilDebugPrint "Making file copy or moving it (using \"${tmpFileMoveAction}\") to: ${tmpFile}"
	"$tmpFileMoveAction" "$argFileName" "$tmpFile"
	argFileName="$tmpFile"
fi

# append argument (or replace FILENAME) and run executable
escapedFileName="$(printf '%q' "$argFileName")"
execute=$( ( [[ "$execute" =~ FILENAME ]] && echo "$execute" | sed -e "s/FILENAME/$(utilSedEscapeReplacement "$escapedFileName")/g" ) || echo "${execute} ${escapedFileName}" )

# if running in silent mode, run program from bash
[[ "$argSilentDetached" -eq 1 ]] && execute="bash -c \"${execute} &>/dev/null &\""

# execute program (or return success if only needed to check if applicable program exists)
utilDebugPrint "Will execute: ${execute}"
if [[ "$argOnlyCheck" -eq 1 ]]; then
	exit 0
else
	eval "exec ${execute}"
fi
