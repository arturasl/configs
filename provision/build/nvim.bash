#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail
shopt -s failglob

symlink() {
    from="${HOME}/$1"
    to="${HOME}/$2"
    if [ -L "$to" ]; then
        return
    fi
    ln -s "$from" "$to"
}

main() {
    sudo pacman --noconfirm -S neovim

    # Additional dependencies requested by :checkhealth
    sudo /usr/bin/vendor_perl/cpanm -n Neovim::Ext
    sudo npm install -g neovim
    yay -S --noconfirm ruby-neovim
    sudo pacman --noconfirm -S python-pynvim
    sudo pacman --noconfirm -S ripgrep fd   # Faster grep & find.
    sudo pacman --noconfirm -S tree-sitter-cli

    # Generates nicer diffs, used by neovim tiny-code-action plugin.
    sudo pacman --noconfirm -S git-delta

    # File structure.
    mkdir -p ~/.config/nvim
    symlink configs/nvim/init.lua .config/nvim/init.lua
    symlink configs/nvim/lua .config/nvim/lua
    symlink configs/nvim/localvimrc.lua .config/nvim/localvimrc.lua
    symlink configs/nvim/.stylua.toml .config/nvim/.stylua.toml
    symlink configs/nvim/snippets .config/nvim/snippets
    symlink configs/nvim/queries .config/nvim/queries
    symlink configs/nvim/ftplugin .config/nvim/ftplugin
    symlink configs/vim .vim
}

main "$@"
