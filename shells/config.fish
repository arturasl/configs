set --export --global CDPATH .

if status --is-interactive
	~/configs/shells/common.bash fish | source
end

# Use ctrn-{n,p,o} to move over history.
bind --mode insert \cn history-search-backward
bind --mode insert \cp history-search-forward
bind --mode insert \co accept-autosuggestion

# Prevent a delay after escaping.
# This is useful for vim mode where we want to go from input mode to normal
# as fast as possible.
set -g fish_escape_delay_ms 10

function caly
	cal --monday --iso --color --year (date '+%Y')
end
