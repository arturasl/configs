#!/bin/bash -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/constants.bash"

initialPlaylist="${HOME}/Music/playlist"
shuffle=true
commandFile=fifo
IFS=$'\n' # evil

#### Cleanup

fnOnFinish() {
	rm -f "$mplayer_pipe" &>/dev/null || true
	rm -f "$commandFile" &>/dev/null || true
	[ -n "$mplayer_pid" ] && kill "$mplayer_pid"
}
trap fnOnFinish EXIT

#### helpers for extracting files to play

fnShuffleLines() {
	awk 'BEGIN{srand();}{print rand()"\t"$0}' | sort -k1 -n | cut -f2-
}

fnGetFilesToPlayFromDirectory() {
	directory="$1"
	find "$directory" -type f -regextype posix-extended -iregex '.*\.(mp3|mp4|flv)$'
}

fnGetFilesToPlayFromPlaylistItem() {
	item="$1"

	for subItem in $(echo -n $item | tr ':' '\n') ; do
		if [ -d "$subItem" ]; then
			fnGetFilesToPlayFromDirectory "$subItem"
		elif [[ -f "$subItem" && "$subItem" =~ \.txt$ ]]; then
			# nested playlist?
			fnGetFilesToPlayFromPlaylist "$subItem"
		else
			# either local mp3 or external radio station
			echo "$subItem"
		fi
	done | sort -u
}

fnGetFilesToPlayFromPlaylist() {
	playlist="$1"
	itemsToPlay="$(cat "$playlist" | sed -e '/^#/d' -e '/^[[:space:]]*$/d')"

	for itemToPlay in $itemsToPlay; do
		fnGetFilesToPlayFromPlaylistItem "$itemToPlay"
	done | sort -u
}

fnInformDzen() {
	playing="$(basename "$1" | tr '_' ' ' | sed -e 's/\..*$//')"
	paused="$2"

	echo -n "^ca(1, echo pause > \"${commandFile}\")"
	if "$paused"; then
		echo -n "^i(${xbmdir}/play.xbm)"
	else
		echo -n "^i(${xbmdir}/pause.xbm)"
	fi
	echo -n '^ca()'

	echo -n ' '

	echo -n "^ca(1, echo next > \"${commandFile}\")"
	echo -n "$playing"
	echo -n '^ca()'

	echo
}

rm -f "$commandFile" &>/dev/null
mkfifo "$commandFile"
mplayer_pipe="$(mktemp temp.XXXX)"

while [ true ]; do
	filesToPlay="$(fnGetFilesToPlayFromPlaylistItem "$initialPlaylist")"
	"$shuffle" && filesToPlay="$(echo "$filesToPlay" | fnShuffleLines)"
	echo "Playlist: $initialPlaylist"

	breakFilePlaying=false

	for file in $filesToPlay; do
        if "$breakFilePlaying"; then
			break;
		fi

		playingIsPaused=false
		rm "$mplayer_pipe" && mkfifo "$mplayer_pipe"
		mplayer -vo null -slave -input "file=${mplayer_pipe}" "$file" 1>/dev/null &
		mplayer_pid="$!"

		fnInformDzen "$file" "$playingIsPaused"

		line=''
		while read -t 2 -r line || kill -0 "$mplayer_pid" &>/dev/null; do
			[ -z "$line" ] && continue

			commandFromLine="$(echo "$line" | cut -d' ' -f1)"

			case "$commandFromLine" in
				pause)
					echo 'p' >"$mplayer_pipe"
					if "$playingIsPaused"; then playingIsPaused=false; else playingIsPaused=true; fi
					fnInformDzen "$file" "$playingIsPaused"
					;;
				next)
					echo 'q' >"$mplayer_pipe"
					break
					;;
				play)
					initialPlaylist="$(echo "$line" | cut -d' ' -f2-)"
					echo 'q' >"$mplayer_pipe"
					breakFilePlaying=true
					break
					;;
			esac

			line=''
		done <>"$commandFile"
	done
done > >(dzen2 $@)
