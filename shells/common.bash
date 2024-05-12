#!/bin/bash

TYPE="$1"

arrayJoin() {
	local sep="$1"
	local val=''

	for (( i = 2; i <= $#; i++ )); do
		[ "$i" -ne 2 ] && val="${val}${sep}"
		val="${val}${!i}"
	done

	echo "$val"
}

arrayPrepend() {
	local name_of_array="$1"
	local val="$2"

	eval "${name_of_array}=( '${val}' \"\${${name_of_array}[@]}\" )"
}

bashExport() {
	local name="$1"

	[ "$TYPE" != bash ] && return
	echo export "${name}='$(arrayJoin : "${@:2}")'"
}

fishExport() {
	local name="$1"

	[ "$TYPE" != fish ] && return
	echo -n "set --global --export '${name}'"
	for val in "${@:2}"; do
		echo -n " '${val}'"
	done
	echo ''
}

agnosticExport() {
	eval "$(bashExport "$@")"
	case "$TYPE" in
		bash) bashExport "$@" ;;
		fish) fishExport "$@" ;;
	esac
}

bashExecute() {
	[ "$TYPE" != bash ] && return
	echo "$1"
}

agnosticExecute() {
	echo "$@"
}

bashAlias() {
	[ "$TYPE" != bash ] && return
	echo "alias ${1}='${2}'"
}

fishAlias() {
	[ "$TYPE" != fish ] && return
	echo "function $1 -d \"\""
	echo -ne "\t" && echo "$2 \$argv"
	echo 'end'
}

agnosticAlias() {
	case "$TYPE" in
		bash) bashAlias "$@" ;;
		fish) fishAlias "$@" ;;
	esac
}

IFS=':' read -r -a A_PATH <<< "$PATH"

#### Constants

test -z "$(uname -a | grep Darwin)"
agnosticExport IS_MAC "$?"

#### Colors for less

# http://nion.modprobe.de/blog/archives/572-less-colors-for-man-pages.html
# man termcap
# \e[ - color def, \e[font attributes;foreground;background
agnosticExport LESS_TERMCAP_so $'\e[0;93m' # start standout (man - search results)
agnosticExport LESS_TERMCAP_se $'\e[0m'

agnosticExport LESS_TERMCAP_md $'\e[1;94m' # start bold (man - titles & parameters)
agnosticExport LESS_TERMCAP_me $'\e[0m'

agnosticExport LESS_TERMCAP_us $'\e[4;95m' # start underline (man - parameter values)
agnosticExport LESS_TERMCAP_ue $'\e[0m'

#### Prompt

# Bash
bashExecute "
promptCommand() {
	local exit_status=\"\$?\"
	local color_off=\"\\e[00m\"
	local red=\"\\e[0;31m\"
	PS1=''
	[ \"\$exit_status\" -ne 0 ] && PS1+=\"\\[\${red}\\]\"
	PS1+=\"\\$\\[\${color_off}\\]\"
	PS1+=' '
}"
bashExport PROMPT_COMMAND promptCommand
# Print before each multiline cmd
bashExport PS2 ' └> '

#### External programs

agnosticExport SHELL "$(which bash)"
agnosticExport EDITOR nvim
agnosticExport BROWSER "${HOME}/configs/scripts/showme.bash"

#### Python

agnosticExport PIP_REQUIRE_VIRTUALENV true
agnosticExport PIP_DOWNLOAD_CACHE "${HOME}/.pip/cache"

#### Locale

agnosticExport LC_ALL en_US.UTF-8
agnosticExport LANG en_US

#### JAVA

if pidof dwm &>/dev/null; then
   agnosticExport _JAVA_AWT_WM_NONREPARENTING 1
fi

#### Key bindings

# Bash
bashExecute 'set -o vi'

#### Aliases

agnosticAlias shufmplayer 'mplayer -vo null -shuffle'
agnosticAlias smplayer 'mplayer -softvol -softvol-max 300'

#### Private stuff

[ -f ~/.bashrc_private ] && source ~/.bashrc_private

#### PATH

arrayPrepend A_PATH "${HOME}/configs/scripts/global/"
agnosticExport PATH "${A_PATH[@]}"
