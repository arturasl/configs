set --export --global fish_greeting '' # do not show greeting message.

if status --is-interactive
    ~/configs/shells/common.bash fish | source
end

# Prompt.

function fish_prompt
    if [ $status -ne 0 ]
        set_color red
    end
    echo -n '$ '
    set_color normal
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

# Vim mode.
set -g fish_key_bindings fish_vi_key_bindings
# Prevent a delay after escaping.
# This is useful for vim mode where we want to go from input mode to normal
# as fast as possible.
set -g fish_escape_delay_ms 10

# Use ctrn-{n,p,o} to move over history.
bind --mode insert \cp history-search-backward
bind --mode insert \cn history-search-forward

# Aliases.
abbr --add cc -- cal --monday --iso --color=always --year
abbr --add ll -- ls --almost-all --human-readable -l --color=always --group-directories-first -v --time-style=long-iso
abbr --add dd -- /bin/date "\"+%Y-%m-%d %H:%M:%ST%z\""

abbr --add vim -- $EDITOR

# -i / --interactive -- ask before overwriting.
# -v / --verbose -- show what happened.
abbr --add cp -- cp -iv
abbr --add mv -- mv -iv

function fzf_file
  fd --type f | fzf
end
abbr --add '**' --position anywhere --function fzf_file

fzf --fish | source
