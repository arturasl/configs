#!/bin/bash -xe

build_dir="${HOME}/Builds/fish"
rm -rf "${build_dir}" && mkdir -p "${build_dir}" && cd "${build_dir}"

git clone git://github.com/fish-shell/fish-shell.git .

autoconf
./configure
make
sudo make install
