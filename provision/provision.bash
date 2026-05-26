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
    ln --force --symbolic "$from" "$to"
}

install() {
    sudo pacman -S --noconfirm --needed "$@"
}

git-get() {
    local from="$1"
    local to="$2"

    mkdir -p "$to"

    if [[ -n "$(ls "$to")" ]]; then
        (cd "$to" && git pull)
        return
    fi

    git clone "$from" "$to"
}

init_system() { # {{{
    # directory structure {{
    mkdir -p ~/Builds/ ~/Tmp
    mkdir -p ~/Projects/{Professional,Personal,Tmp}
    # }}

    install -yu # Full system update.

    # Auto update mirror list.
    sudo systemctl enabled reflector.timer
    sudo systemctl enable reflector.timer

    # Btrfs
    install snapper
    sudo snapper -c root create-config /
    # Show snapshots in the grub menu.
    install inotify-tools grub-btrfs
    sudo systemctl start grub-btrfsd
    sudo systemctl enable grub-btrfsd
    # Create snapshots before/after using pacman.
    install snap-pac
} # }}}

version_control() { # {{
    install subversion
    install mercurial

    install git
    git config --global init.defaultBranch main

    install jujutsu
    symlink configs/jj/config.toml .config/jj/config.toml
} # }}

development() { # {{
    install openssh base-devel make cmake clang gcc # Build essentials.
    install zeal # Offline help docs.

    # Language specific
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

    # Haskell
    yay -S --noconfirm --needed ghcup-hs-bin
    ghcup install ghc
    ghcup install cabal
    ghcup instal hls

    # Rust
    install rustup
    rustup install nightly stable
    rustup default stable

    # Virtual machines
    install virtualbox-host-modules-arch virtualbox
    install virtualbox-guest-{iso,utils}
    # Restart.

    # Debugging
    install wireshark-qt # Network traffic analyzer.
    install afl++ afl-utils # Fuzzier.
    install valgrind # Memory debugger.
} # }}

terminal_tools(){ # {{
    # Utilities.
    install curl
    install zip
    install xsel xclip # Clipboard manipulation.
    yay -S --noconfirm --needed xkb-switch # Query/change current keyboard layout.
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

    # General programs
    install ghostty
    git-get https://github.com/sahaj-b/ghostty-cursor-shaders ~/.config/ghostty/shaders
    symlink configs/ghostty/config .config/ghostty/config

    # Tmux
    install tmux # Multiplexer.
    symlink configs/tmux/tmux.conf .config/tmux/tmux.conf

    # Fish
    install fish
    fish -c 'exit 0' # Start finish to pre-initialize it.
    bash -c '( test -d ~/.config/fish/ && ln -s ~/configs/shells/config.fish ~/.config/fish/config.fish ) || echo "could not find fish"'
    fish -c fish_update_completions

    # Other
    ./build/vifm.bash  # File manager.
    install mosh         # Somewhat more persistent ssh.

    install btop         # Process monitor.
    mkdir -p ~/.config/btop/ && ( btop --default-config && cat ~/configs/btop/btop.conf ) > ~/.config/btop/btop.conf

    # Bluetooth
    install bluez bluez-utils
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
} # }}

editors() { # {{
    ./build/nvim.bash
    yay -S --noconfirm --needed rehex-git # hexadecimal editor.
    install geany
} # }}

security() { # {{
    install keepassxc # Password manager.
} # }}

user_programs() { # {{
    ## Dropbox
    install python-gpgme libappindicator # Deps.
    yay -S --noconfirm --needed dropbox # Simple file syncing.
    dropbox # To login.
    dropbox # To connect with current machine.

    # General
    install chromium firefox # Internet browser.
    install libreoffice
    install anki
    install gparted
    install bc qalculate-qt # Calculator.

    # Multimedia
    install gimp # Image editor.
    install inkscape # Vector graphics editor.
    install mplayer # Audio/video player.
    install vlc vlc-plugins-all # Audio/video player.
    install audacity # Audio recording/editing.

    ## Document viewers
    install zathura{,-djvu,-ps,-pdf-mupdf} # Document preview (pdf, djvu, ps).
    symlink configs/zathura/zathurarc .config/zathura/zathurarc
    install calibre # Epub reader/converter.
    install feh # Image previewing.

    ## Window manager
    install rofi rofi-emoji rofi-calc # Generic Launcher.
    git-get https://github.com/lr-tech/rofi-themes-collection.git ~/Builds/rofi-themes
    symlink Builds/rofi-themes/themes .local/share/rofi/themes
} # }}

fonts() { # {{
    yay -S --noconfirm --needed ttf-ms-win11-auto
    install terminus-font
    install ttf-dejavu ttf-droid
    install nerd-fonts
    ./build/external_fonts.bash
} # }}

desktop_environment() { # {{
    for app in ../autostart/*; do
        app="$(basename "${app}")"
        symlink "configs/autostart/${app}" ".config/autostart/${app}"
    done

    # Gnome
    install gnome-browser-connector
    install gnome gnome-circle

    install-gnome-extension() {
        local extension="$1/@"
        extension="${extension/@/%40}"
        gnome-browser-connector "gnome-extensions://${extension}/?action=install"
    }

    # For rendering thumbnails in the filemanager.
    install ffmpegthumbnailer
    install gnome-epub-thumbnailer

    install-gnome-extension caffeine@patapon.info
    install-gnome-extension system-monitor@gnome-shell-extensions.gcampax.github.com
    install-gnome-extension appindicatorsupport@rgcjonas.gmail.com
    install-gnome-extension weatheroclock@CleoMenezesJr.github.io
    install-gnome-extension MaximizeWindowIntoNewWorkspace@kyleross.com
    install-gnome-extension blur-my-shell@aunetx
    install-gnome-extension extension-list@tu.berry
    install-gnome-extension mouse-tail@lanesun.anlbrain.com
    install-gnome-extension Bluetooth-Battery-Meter@maniacx.github.com
} # }}

# Chrome {{{
# https://chromewebstore.google.com/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep
# https://chromewebstore.google.com/detail/read-on-remarkable/bfhkfdnddlhfippjbflipboognpdpoeh
# https://chromewebstore.google.com/detail/ublock-origin-lite/ddkjiahejlhfcafbddmgiahcphecmpfh
# https://chromewebstore.google.com/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb
# }}}

main() {
    init_system
    version_control
    development
    terminal_tools
    editors
    security
    user_programs
    fonts
    desktop_environment
}

main "$@"
