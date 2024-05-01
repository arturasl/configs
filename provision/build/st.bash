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

# Colors.
wget "https://st.suckless.org/patches/solarized/st-no_bold_colors-0.8.1.diff" --output-document=st-no_bold_colors.diff
patch < "st-no_bold_colors.diff"
wget "https://st.suckless.org/patches/solarized/st-solarized-dark-0.8.5.diff" --output-document=st-solraized-dark.diff
patch < st-solraized-dark.diff

# Allow to resize window to an arbitrary size.
wget "https://st.suckless.org/patches/anysize/st-expected-anysize-0.9.diff" --output-document=st-anysize.diff
patch < st-anysize.diff

# Font.
sed -i'' -e 's/^static char \*font.*$/static char font[] = "DejaVu Sans Mono:pixelsize=14";/g' config.def.h

# Install
make && sudo make install && make clean
