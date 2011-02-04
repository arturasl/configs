####  Source global definitions
if [ -f /etc/bashrc ]; then
	source /etc/bashrc
fi

#### Aliases

alias _grep='grep --with-filename --line-number --initial-tab  --color=always'
alias vim='gvim -v'
# Show each directory in seperate line, show indexes and expand ~ or similar things
alias dirs='dirs -p -l -v'
alias ll='ls --all --human-readable -l --color=auto'
alias dosbox='dosbox -c "mount C ~/Projects/ASM/" -c "C:\\" -c "path=C:\\tasm\\bin\\" -c "cd projects/DIS/"'
alias dmenu_show="dmenu_run -nb '#2E2E2E' -nf '#D6D6D6' -sb '#D6D6D6' -sf '#2E2E2E'"

#### Additional setting

# Fix minor erros in path while using cd builtin
shopt -s cdspell

# Add completion for some programs
if [[ -d "/etc/bash_completion.d/" ]]; then
	nComplete=$(complete -p | wc --lines)
	if [[ "$nComplete" < "5" ]]; then
		for strFile in /etc/bash_completion.d/*; do
			source $strFile
		done
	fi
else
	echo "($BASH_SOURCE: $LINENO) Could not load extended completion files :(" 1>&2
fi

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
	tmux new-window -t arturasl_tmux:3 -n 'newsbeuter' 'newsbeuter'
	tmux new-window -t arturasl_tmux:4 -n 'irssi' 'irssi'
	tmux new-window -t arturasl_tmux:5 -n 'htop' 'htop'

	tmux select-window -t arturasl_tmux:1
	tmux attach-session -t arturasl_tmux
}
