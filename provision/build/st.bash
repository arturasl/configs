#!/bin/bash -xe

build_dir="${HOME}/Builds/st"
rm -rf "${build_dir}" && mkdir -p "${build_dir}" && cd "${build_dir}"

# download
stver=0.8.1
wget "http://dl.suckless.org/st/st-${stver}.tar.gz" \
	&& wget http://dl.suckless.org/st/sha256sums.txt
grep "st-${stver}" sha256sums.txt | sha256sum --check --status
tar xzf "st-${stver}.tar.gz" && mv "st-${stver}"/* . && rm -r "st-${stver}"{,.tar.gz} sha256sums.txt

# colors
wget "https://st.suckless.org/patches/solarized/st-no_bold_colors-${stver}.diff"
patch < "st-no_bold_colors-${stver}.diff"
wget https://st.suckless.org/patches/solarized/st-solarized-dark-20180411-041912a.diff
patch < st-solarized-dark*.diff

# font
sed -i'' -e 's/^static char \*font.*$/static char font[] = "DejaVu Sans Mono:pixelsize=10:antialias=true:autohint=false";/g' config.def.h

# install
sudo make install && make clean
