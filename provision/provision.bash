#!/usr/bin/env bash
# vim: foldmethod=marker
# vim: foldmarker={{,}}

set -o nounset
set -o errexit
set -o pipefail
shopt -s failglob

symlink() {
    local from="${HOME}/$1"
    local to="${HOME}/$2"
    mkdir -p "$(dirname "$to")"
    if [ -L "$to" ]; then
        return
    fi
    ln -s "$from" "$to"
}

install() {
    sudo pacman -S --noconfirm "$@"
}

git-get() {
    local from="$1"
    local to="${HOME}/$2"

    mkdir -p "$to"

    if [[ -n "$(ls "$to")" ]]; then
        (cd "$to" && git pull)
        return
    fi

    git clone "$from" "$to"
}

install-gnome-extension() {
    local extension="$1/@"
    extension="${extension/@/%40}"
    gnome-browser-connector "gnome-extensions://${extension}/?action=install"
}

# directory structure {{
mkdir -p ~/Builds/ ~/Tmp
mkdir -p ~/Projects/{Professional,Personal,Tmp}
# }}

install -yu # Full system update.

# Development {{
install base-devel make cmake clang gcc # Build essentials.
install openssh subversion mercurial # Version control
install git
git config --global init.defaultBranch main
install jujutsu
symlink configs/jj.toml .config/jj/config.toml
install zeal # Offline help docs.

## Language specific {{
install python python-pip python-pipx python-setuptools uv # Python
install fpc # Pascal
install nodejs npm # JavaScript
install lua lua51 luarocks # Lua
install go # Go
install texlive-{meta,langeuropean} # LaTeX
install php composer # Php
install perl cpanminus # Perl
install ruby
install julia
install jdk-openjdk openjdk-doc openjdk-src # Java
install clojure leiningen # Clojure
install graphviz # Graph drawing utility/language.
# Rust {{
install rustup
rustup install nightly stable
rustup default stable
# }}
## }}

## Virtual machines {{
install virtualbox-host-modules-arch virtualbox
install virtualbox-guest-{iso,utils}
# Restart.
## }}

## Debugging {{
install wireshark-qt # Network traffic analyzer.
install afl++ afl-utils # Fuzzier.
install valgrind # Memory debugger.
## }}

./build/nvim.bash
yay -S --noconfirm rehex-git # hexadecimal editor.
## }}

# Terminal tools {{
## Utilities {{
install curl
install zip
install xsel xclip # Clipboard manipulation.
yay -S --noconfirm xkb-switch # Query/change current keyboard layout.
install arandr # Managing monitor positions.
install imagemagick # Converts between various image formats (screen capture, filters, etc.)
install pandoc # Converts between various document formats (mkd, latex, rst, etc.)
install sshfs curlftpfs fuse-zip # Fuse.
install moreutils # Various small utils like sponge
install time # /usr/bin/time
install hyperfine # Benchmarking utility.
install fzf # Fuzzy autocomplete window
install ncdu # Show file size statistics.
pipx install semgrep # Search via abstract syntax tree.
## }}
## General programs {{
install ghostty
git-get https://github.com/sahaj-b/ghostty-cursor-shaders ~/.config/ghostty/shaders
symlink configs/ghostty.config .config/ghostty/config
## Tmux {{
install tmux # Multiplexer.
symlink configs/tmux.conf .tmux.conf
# }}
## Fish {{
install fish
fish -c 'exit 0' # Start finish to pre-initialize it.
bash -c '( test -d ~/.config/fish/ && ln -s ~/configs/shells/config.fish ~/.config/fish/config.fish ) || echo "could not find fish"'
fish -c fish_update_completions
# }}
./build/vifm.bash  # File manager.
install mosh         # Somewhat more persistent ssh.

install btop         # Process monitor.
btop --version >/dev/null
cat ~/configs/btop.conf >> ~/.config/btop/btop.conf

install git-delta # Generates nicer diffs, used by neovim tiny-code-action plugin.

## Bluetooth {{
install bluez bluez-utils
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
# }}

## }}
# }}

# Security {{
install keepassxc # Password manager.
# }}

# User level programs {{
## General {{
## Dropbox {{
yay -S --noconfirm dropbox # Simple file syncing.
dropbox # To login.
dropbox # To connect with current machine.
# }}

install chromium firefox # Internet browser.
install libreoffice
install gparted
install bc qalculate-qt # Calculator.
## }}
## multimedia  {{
install gimp # Image editor.
install inkscape # Vector graphics editor.
install mplayer # Audio/video player.
install vlc vlc-plugins-all # Audio/video player.
install audacity # Audio recording/editing.
## }}
## document viewers {{
install zathura{,-djvu,-ps,-pdf-mupdf} # Document preview (pdf, djvu, ps).
symlink configs/zathurarc .config/zathura/zathurarc
install calibre # Epub reader/converter.
install feh # Image previewing.
## }}
## window manager{{
install rofi # Generic Launcher.
## }}
## fonts {{
yay -S --noconfirm ttf-ms-win10-auto
install terminus-font
install ttf-dejavu ttf-droid
install nerd-fonts
./build/external_fonts.bash
## }}
#  }}

# Desktop Environment {{{

symlink configs/autostart .config/autostart

# Gnome {{{
install gnome-browser-connector

install-gnome-extension caffeine@patapon.info
install-gnome-extension system-monitor@gnome-shell-extensions.gcampax.github.com
install-gnome-extension appindicatorsupport@rgcjonas.gmail.com
install-gnome-extension weatheroclock@CleoMenezesJr.github.io
install-gnome-extension maximize-workspace-history@amancode22.github.com
install-gnome-extension dash-in-panel@fthx
install-gnome-extension blur-my-shell@aunetx
install-gnome-extension extension-list@tu.berry
install-gnome-extension mouse-tail@lanesun.anlbrain.com
install-gnome-extension Bluetooth-Battery-Meter@maniacx.github.com
# }}}

#}}}

# Chrome {{{
# https://chromewebstore.google.com/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep
# https://chromewebstore.google.com/detail/read-on-remarkable/bfhkfdnddlhfippjbflipboognpdpoeh
# https://chromewebstore.google.com/detail/ublock-origin-lite/ddkjiahejlhfcafbddmgiahcphecmpfh
# https://chromewebstore.google.com/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb
# }}}
