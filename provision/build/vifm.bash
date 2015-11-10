#!/bin/bash -xe

build_dir="${HOME}/Builds/vifm"
rm -rf "${build_dir}" && mkdir -p "${build_dir}" && cd "${build_dir}"

git clone https://github.com/vifm/vifm.git .
./configure && make && sudo make install

# color schemes
mkdir -p ~/.vifm/colors && rm -rf ~/.vifm/colors/*
git clone https://github.com/vifm/vifm-colors.git ~/.vifm/colors

# for previewing
sudo apt-get -y install python-pygments
sudo apt-get -y install docx2txt antiword odt2txt
sudo apt-get -y install mediainfo
