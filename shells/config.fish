set --export --global CDPATH .
set --export --global fish_greeting '' # do not show greeting message.

if status --is-interactive
	~/configs/shells/common.bash fish | source
end

function fish_prompt
	if [ $status -ne 0 ]
		set_color red
	end
	echo -n '$ '
	set_color normal
end

function fish_user_key_bindings
	fish_vi_key_bindings
end

function fish_mode_prompt
	switch $fish_bind_mode
		case default
			echo -n N
		case insert
			echo -n I
		case replace-one
			echo -n R
		case visual
			echo -n V
		case '*'
			echo -n '?'
	end
	echo ' '
end

# Prevent a delay after escaping.
# This is useful for vim mode where we want to go from input mode to normal
# as fast as possible.
set -g fish_escape_delay_ms 10

# Use ctrn-{n,p,o} to move over history.
bind --mode insert \cp history-search-backward
bind --mode insert \cn history-search-forward
bind --mode insert \co accept-autosuggestion

# Aliases.
function cc
	cal --monday --iso --color --year (date '+%Y')
end

function ll 
	ls -a --human-readable -l --color=auto --group-directories-first -v $argv
end

function dd
	/bin/date "+%Y-%m-%d %H:%M:%ST%z"
end
