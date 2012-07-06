####  Source global definitions
if [ -f /etc/bashrc ]; then
	source /etc/bashrc
fi

#### Aliases

alias _grep='grep --with-filename --line-number --initial-tab  --color=always'
alias vim='gvim -v'
# Show each directory in seperate line, show indexes and expand ~ or similar things
alias dirs='dirs -p -l -v'
alias ll='ls --all --human-readable -l --color=auto --group-directories-first -v'
alias dosbox='dosbox -c "mount C ~/Projects/ASM/" -c "C:\\" -c "path=C:\\tasm\\bin\\" -c "cd projects/DIS/"'
alias tmux='tmux -2'

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

# Explicitly move to home directory
cd

#### Strings

# Print before each cmd
PS1="\$ "
# Print before each multiline cmd
PS2=" └> "

#### Tmux

function atmux(){
	cd

	tmux start-server

	tmux new-session -d -s arturasl_tmux -n 'bash'
	tmux new-window -t arturasl_tmux:2 -n 'zsh' 'zsh'
	tmux new-window -t arturasl_tmux:3 -n 'news' 'podbeuter'
	tmux split-window -v -p 90 -t arturasl_tmux:3 'newsbeuter'
	tmux new-window -t arturasl_tmux:4 -n 'irssi' 'irssi'
	tmux new-window -t arturasl_tmux:5 -n 'htop' 'htop'

	tmux select-window -t arturasl_tmux:1
	tmux -2 attach-session -t arturasl_tmux
}

#### Private stuff
source ~/.bashrc_private
