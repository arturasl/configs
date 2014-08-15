set fish_greeting "" # do not show greeting message

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
