#!/bin/bash -xe

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

build_dir="${HOME}/Builds/dwm"
rm -rf "${build_dir}" && mkdir -p "${build_dir}" && cd "${build_dir}"

# download and patch

wget -O dwm.tar.gz https://dl.suckless.org/dwm/dwm-6.2.tar.gz
tar xzf dwm.tar.gz && mv dwm-*/* . && rm -rf dwm.tar.gz

wget -O systray.diff https://dwm.suckless.org/patches/systray/dwm-systray-20190208-cb3f58a.diff
patch -i systray.diff

wget -O pertag.patch https://dwm.suckless.org/patches/pertag/dwm-pertag-20170513-ceac8c9.diff
patch -i pertag.patch

# diff --show-c-function -u --ignore-blank-lines ~/Builds/dwm/config.def.h config.h > config.h.patch
cp "${SCRIPT_DIR}/config.h.patch" .
patch -i config.h.patch

# build

make
sudo rm -f /usr/bin/dwm
sudo cp "${build_dir}/dwm" /usr/bin/
