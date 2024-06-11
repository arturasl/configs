#!/bin/bash -xe

build_dir="${HOME}/Builds/st"
rm -rf "${build_dir}"
mkdir -p "${build_dir}"
cd "${build_dir}"

# Download.
stver=0.9.2
wget "http://dl.suckless.org/st/st-${stver}.tar.gz" \
	&& wget http://dl.suckless.org/st/sha256sums.txt
grep "st-${stver}" sha256sums.txt | sha256sum --check --status
tar xzf "st-${stver}.tar.gz" && mv "st-${stver}"/* . && rm -r "st-${stver}"{,.tar.gz} sha256sums.txt

# Draw various lines without gaps.
wget "https://st.suckless.org/patches/boxdraw/st-boxdraw_v2-0.8.5.diff" --output-document=st-boxdraw.diff
patch -p1 < st-boxdraw.diff
sed -i'' -e 's/int boxdraw = 0;/int boxdraw = 1;/g' config.def.h
sed -i'' -e 's/int boxdraw_bold = 0;/int boxdraw_bold = 1;/g' config.def.h

# Do not change color of bold text.
wget "https://st.suckless.org/patches/bold-is-not-bright/st-bold-is-not-bright-20190127-3be4cf1.diff" --output-document=st-bold-is-not-bright.diff
patch < st-bold-is-not-bright.diff

# Colors.
wget "https://st.suckless.org/patches/dracula/st-dracula-0.8.5.diff" --output-document=st-dracula.diff
patch < st-dracula.diff

# Allow to resize window to an arbitrary size.
wget "https://st.suckless.org/patches/anysize/st-expected-anysize-0.9.diff" --output-document=st-anysize.diff
patch < st-anysize.diff

# Font.
sed -i'' -e 's/^static char \*font.*$/static char font[] = "DejaVuSansM Nerd Font Mono:pixelsize=14";/g' config.def.h

# Install
make && sudo make install && make clean
