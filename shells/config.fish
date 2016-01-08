set --export --global CDPATH .

if status --is-interactive
	~/configs/shells/common.bash fish | source
end
