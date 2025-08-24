# Do not show greeting message.
set --export --global fish_greeting ''

# Run ls after changing directory (change in PWD variable).
function list_dir --on-variable PWD
    ls
end

###### Exports.

set --export --global SHELL "$(which bash)"
set --export --global EDITOR nvim
set --export --global LC_ALL en_US.UTF-8
set --export --global LANG en_US.UTF-8
fish_add_path --path --append "$HOME/configs/scripts/global/"

###### Prompt.

function fish_prompt
    set --local s $status
    if [ $s -ne 0 ]
        set_color red
        echo -n "[$s] "
        set_color normal
    end
    echo -n '$ '
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

###### Colors.

# http://nion.modprobe.de/blog/archives/572-less-colors-for-man-pages.html
# man termcap
# \e[ - color def, \e[font attributes;foreground;background
# Standout (man -- search results).
set --export --global LESS_TERMCAP_so "$(echo -e '\e[0;93m')"
set --export --global LESS_TERMCAP_se "$(echo -e '\e[0m')"

# Bold (man -- titles & parameters).
set --export --global LESS_TERMCAP_md "$(echo -e '\e[1;94m')"
set --export --global LESS_TERMCAP_me "$(echo -e '\e[0m')"

# Underline (man -- parameter values).
set --export --global LESS_TERMCAP_us "$(echo -e '\e[4;95m')"
set --export --global LESS_TERMCAP_ue "$(echo -e '\e[0m')"

set --export --global GROFF_NO_SGR 1

###### Vim mode (use `fish_key_reader` to find key escape sequences)

set -g fish_key_bindings fish_vi_key_bindings
# Prevent a delay after escaping.
# This is useful for vim mode where we want to go from input mode to normal
# as fast as possible.
set -g fish_escape_delay_ms 10

function vim_bind
    for mod in (string split , "$argv[1]")
        if test "$mod" = "n"
            set --function mod default
        else if test "$mod" = "i"
            set --function mod insert
        else
            echo "Unknown vim modifier '$mod'"
            exit 1
        end

        bind --mode "$mod" "$argv[2]" "$argv[3]"
    end
end

# Use ctrn-{n,p,o} to move over history.
vim_bind n,i ctrl-p history-search-backward
vim_bind n,i ctrl-n history-search-forward
# Tab to use proposed completion.
vim_bind n,i ctrl-y accept-autosuggestion
# Disable arrow keys.
vim_bind n,i up 'true'
vim_bind n,i down 'true'
vim_bind n,i left 'true'
vim_bind n,i right 'true'
# Esc in normal mode moves into editor.
vim_bind n escape edit_command_buffer

###### Aliases.

abbr --add cc -- cal --monday --iso --color=always --year
abbr --add ll -- ls --almost-all --human-readable -l --color=always --group-directories-first -v --time-style=long-iso
abbr --add dd -- /bin/date "\"+%Y-%m-%d %H:%M:%ST%z\""
abbr --add vim -- $EDITOR
abbr --add vimdiff -- $EDITOR -d
abbr --add ncdu -- ncdu --threads=4 --show-hidden --show-itemcount --show-percent --color dark
abbr --add btop -- btop --preset 1

# -i / --interactive -- ask before overwriting.
# -v / --verbose -- show what happened.
abbr --add cp -- cp -iv
abbr --add mv -- mv -iv
abbr --add rm -- rm -v

function fzf_file
    fd --type f | fzf --height=50% --layout reverse --border=bold --preview='~/configs/scripts/showme.bash --view-text-stream {}'
end
abbr --add '**' --position anywhere --function fzf_file

fzf --fish | source
