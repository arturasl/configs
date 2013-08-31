#!/bin/bash
# author: Artūras Lapinskas

# prepare clean ups
tmpFile=$(mktemp -t $(basename "$0").XXXXXXXXX)
pidCocoaDialog=''
function finish {
	rm -f "$tmpFile"
	[ -n "$pidCocoaDialog" ] && kill "$pidCocoaDialog"
}
trap finish EXIT

# read parameters
argDoNotOpenIfSingle=0
argDoNotFailIfNone=0
declare -a argJoinIfBegins
declare -a argJoinIfEnds

while [ "$#" -ne '0' ]; do
	case "$1" in
		--help)
cat <<EOF
$0 [parameters] *file(s) to read urls from*
reads urls from file, summarizes them and present to the user. After user selects
one - opens it in the browser. If file is not specified, reads from *stdin*.
\`--help\`
:	shows this help information.
\`--join-if-begins str\`
:	if line begins with specified string joins it to previous one.
\`--join-if-ends str\`
:	if line ends with specified string joins it to previous one.
\`--do-not-open-if-single\`
:	by default if only single url is found it is opened without showing it to user.
	This flag supress this behaviour.
\`--do-not-fail-if-none\`
:	by default if no urls are found this script exists with status code of 1. This
	flag supresses this behaviour.
EOF
			exit 0
			;;
		--join-if-begins)
			argJoinIfBegins+=("$2")
			shift 2
			;;
		--join-if-ends)
			argJoinIfEnds+=("$2")
			shift 2
			;;
		--do-not-open-if-single)
			argDoNotOpenIfSingle=1
			shift 1
			;;
		--do-not-fail-if-none)
			argDoNotFailIfNone=1
			shift 1
			;;
		*)
			if [ ! -r "$1" ]; then
				echo "Can not read $1" 2>&1
				exit 1
			fi
			exec <"$1"
			shift 1
			;;
	esac
done

data="$(cat)"

# join lines if needed
for begining in "${argJoinIfBegins[@]}"; do
	data="$(echo -n "$data" | awk -v "begining=${begining}" 'BEGIN{ln=length(begining)}!f{f=1;prevv=$0;next}{s=substr($0,1,ln);if(s==begining){prevv=prevv substr($0,ln+1)}else{printf "%s\n%s",prevv,$0;prevv=""}}END{if(prevv!="")print prevv}')"
done

for ending in "${argJoinIfEnds[@]}"; do
	data="$(echo -n "$data" | awk -v "ending=${ending}" 'BEGIN{ln=length(ending);nextv=""}{s=substr($0,length($0)-ln+1);if(s==ending){nextv=nextv substr($0,1,length($0)-ln)}else{printf "%s%s\n",nextv,$0;nextv=""}}END{if(nextv!="")print nextv}')"
done

# find urls
availableUrls="$(echo -n "$data" | grep --only-matching --extended-regexp -e '(https?:\/\/|www\.)(%[0-9a-fA-F]{2}|[-a-zA-Z0-9._~:\/#?&+;=,])*')"
numberOfAvailableUrls="$(echo "$availableUrls" | awk '/./{l+=1}END{print l+0}')" # wc -l counts "\n" on OSX

# test short circuits
[ "$argDoNotOpenIfSingle" -eq 0 -a "$numberOfAvailableUrls" -eq 1 ] && exec ~/configs/scripts/showme.bash "$availableUrls"
[ "$argDoNotFailIfNone" -eq 0 -a "$numberOfAvailableUrls" -eq 0 ] && exit 1

# open selection menu
if [ -x /Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog ]; then
	availableUrls="$(echo 'quit' && echo "$availableUrls")"
	/Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog dropdown --items $(echo "$availableUrls" | tr "\n" ' ') --button1 ">" --float --exit-onchange >"$tmpFile" &
	pidCocoaDialog="$!"
	osascript <<EOF
tell application "CocoaDialog"
	activate
	tell application "System Events"
		keystroke " "
	end tell
end tell
EOF

	wait "$pidCocoaDialog"
	pidCocoaDialog=''
	if [ "$(sed -n -e 1p "$tmpFile")" -eq 4 ]; then # actually selected something
		selectedItem=$(sed -n -e 2p "$tmpFile")
		selectedItem=$((selectedItem + 1))
		selectedUrl="$(echo "$availableUrls" | sed -n -e "${selectedItem}p")"
	fi
else
	selectedUrl=$(echo -n "$availableUrls" | dmenu -l 10 -nb '#2E2E2E' -nf '#D6D6D6' -sb '#D6D6D6' -sf '#2E2E2E')
fi

# open url
[ -n "$selectedUrl" -a "$selectedUrl" != 'quit' ] && exec ~/configs/scripts/showme.bash "$selectedUrl"
exit 1
