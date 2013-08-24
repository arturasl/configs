set fish_greeting "" # do not show greeting message

function fish_prompt
	if [ $status -ne 0 ]
		set_color red
	end
	echo -n '$ '
	set_color normal
end
