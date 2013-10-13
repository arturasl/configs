#!/bin/bash

# requires:
# * jpegtran - from libjpeg
# * optipng
# * imagemagick

source "$(dirname "$0")/util.bash"

argDEBUG=0
argInterlaceTreshold=300
argFileName=''
argIgnoreNotOptimizedError=0

while [ "$#" -ne '0' ]; do
	case "$1" in
		--help)
echo "$0 [parameters] *file or directory to compress*"
cat <<EOF
\`--help\`
:	shows this help information.

\`--debug\`
:	if present additional debuging information will be shown

\`--interlace-treshold [bytes]\`
:	if file is larger than givenbytes than interlacing will be
	enabled

\`--ignore-not-optimized-error\`
:	if this flag is set no error message will be outputed for
	files that there not optimized

EOF
echo "Example usage: $0 input.png"
			exit 0
			;;
		--debug)
			argDEBUG='1' && shift 1
			;;
		--interlace-treshold)
			argInterlaceTreshold="$2" && shift 2
			;;
		--ignore-not-optimized-error)
			argIgnoreNotOptimizedError=1 && shift 1
			;;
		*)
			[ -n "$argFileName" ] && utilShowError "File specified multiple time (old value = \"${argFileName}\", new value = \"${1}\")"
			argFileName="$1" && shift 1
			;;
	esac
done

utilDebugShowArguments

compressJPG () {
	rm "$2" && jpegtran -copy none -optimize -outfile "$2" "$1"
}

compressPNG () {
	in="$1"
	out="$2"

	if [ "$(utilGetFileSize "$in")" -gt "$argInterlaceTreshold" ]; then
		# if interlacing is applicable then replace $in with interlaced image
		tmp="$(utilCreateTmpFile)" && convert "$in" -interlace PNG "$tmp" && in="$tmp"
	fi

	rm "$out" && optipng -quiet -o7 -out "$out" "$in"
	[ -n "$tmp" ] && rm "$tmp"
}

compressFile () {
	out="$(utilCreateTmpFile)"

	case "$1" in
		*.png)
			compressPNG "$1" "$out"
			;;
		*.jpg | *.jpeg)
			compressJPG "$1" "$out"
			;;
		*)
			utilShowError "Skipping unknown file: $1"
			return
			;;
	esac

	savedBytes=$(($(utilGetFileSize "$1") - $(utilGetFileSize "$out")))
	utilDebugPrint "Optimized $1 by $savedBytes bytes"

	if [ "$savedBytes" -ge 0 ]; then
		cat "$out" > "$1" # use cat to preserve permissions (sadly not atomic :()
	else
		[ "$argIgnoreNotOptimizedError" -ne '1' ] && utilShowError "Could not optimize $1"
	fi

	rm "$out"
}

compressDirectory () {
	OLDIFS="$IFS" && IFS=$'\n'
	for fp in $(find "$1" -name '*.png' -o -name '*.jpg' -o -name '*.jpeg'); do
		compressFile "$fp"
	done
	IFS="$OLDIFS"
}

if [ -d "$argFileName" ]; then
	compressDirectory "$argFileName"
else
	compressFile "$argFileName"
fi
