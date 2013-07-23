#### Constants

test -z "$(uname -a | grep Darwin)"
IS_MAC=$?

####  Source global definitions

if [ -f /etc/bashrc ]; then
	source /etc/bashrc
fi

#### History

# save as much history as we can
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTCONTROL=ignoredups               # ignore same lines if they go successively
export HISTTIMEFORMAT='%y-%m-%d %H:%M:%S> ' # add timestamps near all commands
shopt -s histappend                         # do not overwrite history files from different sessions - append
shopt -s cmdhist                            # combine lines of multiline command by adding semicolons there necessary

#### Colors for less

# http://nion.modprobe.de/blog/archives/572-less-colors-for-man-pages.html
# man termcap
# \e[ - color def, \e[font attributes;foreground;background
export LESS_TERMCAP_so=$'\e[0;93m' # start standout (man - search results)
export LESS_TERMCAP_se=$'\e[0m'

export LESS_TERMCAP_md=$'\e[1;94m' # start bold (man - titles & parameters)
export LESS_TERMCAP_me=$'\e[0m'

export LESS_TERMCAP_us=$'\e[4;95m' # start underline (man - parameter values)
export LESS_TERMCAP_ue=$'\e[0m'

#### Additional setting

# Fix minor erros in path while using cd builtin
shopt -s cdspell

# Add completion for some programs
if [ $IS_MAC != 1 ]; then
	if [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	elif [[ -d "/etc/bash_completion.d/" ]]; then
		nComplete=$(complete -p | wc --lines)
		if [[ "$nComplete" < "5" ]]; then
			for strFile in /etc/bash_completion.d/*; do
				source $strFile
			done
		fi
	else
		echo "($BASH_SOURCE: $LINENO) Could not load extended completion files :(" 1>&2
	fi
fi

# Explicitly move to home directory
cd

#### Strings

# Print before each cmd
PS1="\$ "
# Print before each multiline cmd
PS2=" └> "

#### External programs

export EDITOR=vim
export BROWSER=~/configs/scripts/showme.bash

#### Private stuff

[ -f ~/.bashrc_private ] && source ~/.bashrc_private

#### Aliases

alias grep='grep --with-filename --line-number --color=always'
# this might override existing programs...
export PATH=~/configs/scripts/aliases:$PATH

#### Fish shell

# if we have fish shell use it
# yes, it can be set as default shell...
which fish &>/dev/null
if [ "$?" -eq 0 ]; then
	export CDPATH=.
	exec fish
fi
