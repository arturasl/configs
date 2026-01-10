#!/bin/bash -xe
# vim: foldmethod=marker
# vim: foldmarker={{,}}

symlink() {
    from="${HOME}/$1"
    to="${HOME}/$2"
    mkdir -p "$(dirname "$to")"
    if [ -L "$to" ]; then
        return
    fi
    ln -s "$from" "$to"
}

# directory structure {{
mkdir -p ~/Builds/ ~/Tmp
mkdir -p ~/Projects/{Professional,Personal,Tmp}
# }}

sudo pacman -Syu

# Development {{
sudo pacman -S base-devel make cmake clang gcc # Build essentials.
sudo pacman -S openssh subversion mercurial # Version control
sudo pacman -S git
git config --global init.defaultBranch main
sudo pacman -S jujutsu
symlink configs/jj.toml .config/jj/config.toml
sudo pacman -S zeal # Offline help docs.

## Language specific {{
sudo pacman -S python python-pip python-pipx python-setuptools uv # Python
sudo pacman -S fpc # Pascal
sudo pacman -S nodejs npm # JavaScript
sudo pacman -S lua lua51 luarocks # Lua
sudo pacman -S go # Go
sudo pacman -S texlive-{meta,langeuropean} # LaTeX
sudo pacman -S php composer # Php
sudo pacman -S perl cpanminus # Perl
sudo pacman -S ruby
sudo pacman -S julia
sudo pacman -S jdk-openjdk openjdk-doc openjdk-src # Java
sudo pacman -S leiningen # Clojure
sudo pacman -S graphviz # Graph drawing utility/language.
# Rust {{
sudo pacman -S rustup
rustup install nightly stable
rustup default stable
# }}
## }}

## Virtual machines {{
sudo pacman -S virtualbox-host-modules-arch virtualbox
sudo pacman -S virtualbox-guest-{iso,utils}
# Restart.
## }}

## Debugging {{
sudo pacman -S wireshark-qt # Network traffic analyzer.
sudo pacman -S afl++ afl-utils # Fuzzier.
sudo pacman -S valgrind # Memory debugger.
## }}

./build/nvim.bash
## }}

# Terminal tools {{
## Utilities {{
sudo pacman -S curl
sudo pacman -S zip
sudo pacman -S xsel xclip # Clipboard manipulation.
yay -S xkb-switch # Query/change current keyboard layout.
sudo pacman -S arandr # Managing monitor positions.
sudo pacman -S imagemagick # Converts between various image formats (screen capture, filters, etc.)
sudo pacman -S pandoc # Converts between various document formats (mkd, latex, rst, etc.)
sudo pacman -S sshfs curlftpfs fuse-zip # Fuse.
sudo pacman -S moreutils # Various small utils like sponge
sudo pacman -S time # /usr/bin/time
sudo pacman -S hyperfine # Benchmarking utility.
sudo pacman -S fzf # Fuzzy autocomplete window
sudo pacman -S ncdu # Show file size statistics.
pipx install semgrep # Search via abstract syntax tree.
## }}
## General programs {{
sudo pacman -S ghostty
ln -s  ~/configs/ghostty.config ~/.config/ghostty/config
## Tmux {{
sudo pacman -S tmux # Multiplexer.
ln -s  ~/configs/tmux.conf ~/.tmux.conf
# }}
## Fish {{
sudo pacman -S fish
fish -c 'exit 0' # Start finish to pre-initialize it.
bash -c '( test -d ~/.config/fish/ && ln -s ~/configs/shells/config.fish ~/.config/fish/config.fish ) || echo "could not find fish"'
fish -c fish_update_completions
# }}
./build/vifm.bash  # File manager.
sudo pacman -S mosh         # Somewhat more persistent ssh.

sudo pacman -S btop         # Process monitor.
btop --version >/dev/null
cat ~/configs/btop.conf >> ~/.config/btop/btop.conf

sudo pacman -S git-delta # Generates nicer diffs, used by neovim tiny-code-action plugin.

## Bluetooth {{
sudo pacman -S bluez bluez-utils
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
# }}

## }}
# }}

# Security {{
sudo pacman -S keepassxc # Password manager.
# }}

# User level programs {{
## General {{
## Dropbox {{
yay -S dropbox # Simple file syncing.
dropbox # To login.
dropbox # To connect with current machine.
# }}

sudo pacman -S chromium firefox # Internet browser.
sudo pacman -S libreoffice
sudo pacman -S gparted
sudo pacman -S bc qalculate-qt # Calculator.
## }}
## multimedia  {{
sudo pacman -S gimp # Image editor.
sudo pacman -S inkscape # Vector graphics editor.
sudo pacman -S mplayer # Audio/video player.
sudo pacman -S vlc vlc-plugins-all # Audio/video player.
sudo pacman -S audacity # Audio recording/editing.
## }}
## document viewers {{
sudo pacman -S zathura{,-djvu,-ps,-pdf-mupdf} # Document preview (pdf, djvu, ps).
sudo pacman -S calibre # Epub reader/converter.
sudo pacman -S feh # Image previewing.
## }}
## window manager{{
sudo pacman -S rofi # Generic Launcher.
## }}
## fonts {{
yay -S ttf-ms-win10-auto
sudo pacman -S terminus-font
sudo pacman -S ttf-dejavu ttf-droid
sudo pacman -S nerd-fonts
./build/external_fonts.bash
## }}
#  }}
