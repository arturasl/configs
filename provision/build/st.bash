#!/bin/bash -xe

build_dir="${HOME}/Builds/st"
rm -rf "${build_dir}" && mkdir -p "${build_dir}" && cd "${build_dir}"

# download
stname=st-0.6
wget "http://dl.suckless.org/st/${stname}.tar.gz" \
	&& wget http://dl.suckless.org/st/sha1sums.txt
grep "$stname" sha1sums.txt | sha1sum --check --status
tar xzf "${stname}.tar.gz" && mv "$stname"/* . && rm -r "$stname"{,.tar.gz} sha1sums.txt

# colors
wget "http://st.suckless.org/patches/${stname}-no-bold-colors.diff"
patch < "${stname}-no-bold-colors.diff"
wget http://st.suckless.org/patches/st-solarized-dark.diff
patch < st-solarized-dark.diff

# install
sudo make install && make clean
