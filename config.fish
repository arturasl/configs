set fish_greeting "" # do not show greeting message

function fish_prompt
	echo -n '$ '
end

alias grep='grep --with-filename --line-number --color=always'