#!/bin/bash -xe

symlink() {
    from="${HOME}/$1"
    to="${HOME}/$2"
    if [ -L "$to" ]; then
        return
    fi
    ln -s "$from" "$to"
}

sudo pacman --noconfirm -S neovim

# Additional dependencies requested by :checkhealth
sudo /usr/bin/vendor_perl/cpanm -n Neovim::Ext
sudo npm install -g neovim
yay -S ruby-neovim
sudo pacman --noconfirm -S python-pynvim
sudo pacman --noconfirm -S ripgrep fd   # Faster grep & find.

# File structure.
mkdir -p ~/.config/nvim
symlink configs/nvim/init.lua .config/nvim/init.lua
symlink configs/nvim/lua .config/nvim/lua
symlink configs/nvim/localvimrc.lua .config/nvim/localvimrc.lua
symlink configs/nvim/.stylua.toml .config/nvim/.stylua.toml
symlink configs/nvim/snippets .config/nvim/snippets
symlink configs/vimrc .vimrc
symlink configs/vim .vim
