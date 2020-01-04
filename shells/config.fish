set --export --global CDPATH .

if status --is-interactive
	~/configs/shells/common.bash fish | source
end

# Prevent a delay after escaping.
# This is useful for vim mode where we want to go from input mode to normal
# as fast as possible.
set -g fish_escape_delay_ms 10
