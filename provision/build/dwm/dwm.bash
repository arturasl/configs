#!/bin/bash -xe

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

build_dir="${HOME}/Builds/dwm"
rm -rf "${build_dir}" && mkdir -p "${build_dir}" && cd "${build_dir}"

# download and patch

wget -O dwm.tar.gz http://dl.suckless.org/dwm/dwm-6.0.tar.gz
echo '35346f873a27f219ae266594b3690407f95d06ef  dwm.tar.gz' | sha1sum --status --check -
tar xzf dwm.tar.gz && mv dwm-*/* . && rm -rf dwm.tar.gz

wget -O systray.diff http://dwm.suckless.org/patches/dwm-6.0-systray.diff
patch -i systray.diff

wget -O pertag.patch http://dwm.suckless.org/patches/dwm-6.1-pertag.diff
echo '037f961c447c6278bba6e4514668b6b0c7a3f8f6  pertag.patch' | sha1sum --status --check -
patch -i pertag.patch

# diff --show-c-function -u --ignore-blank-lines ~/Builds/dwm/config.def.h config.h > config.h.patch
cp "${SCRIPT_DIR}/config.h.patch" .
patch -i config.h.patch

# build

make
sudo rm -f /usr/bin/dwm
sudo cp "${build_dir}/dwm" /usr/bin/
