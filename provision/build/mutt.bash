#!/bin/bash -xe

build_dir="${HOME}/Builds/mutt"
rm -rf "${build_dir}" && mkdir -p "${build_dir}" && cd "${build_dir}"

sudo apt-get build-dep mutt
# TODO: maybe no longer needed
sudo apt-get -y install openssl libsasl2-2 libsasl2-{modules,dev} libssl-dev
sudo apt-get -y install libtokyocabinet{9,-dev}
sudo apt-get -y install libgss{3,-dev} libkrb5{-dev,-3}

# download
wget -O mutt.tar.gz https://bitbucket.org/mutt/mutt/downloads/mutt-1.5.23.tar.gz

# check key
wget -O sig.tar.gz.asc https://bitbucket.org/mutt/mutt/downloads/mutt-1.5.23.tar.gz.asc
wget -O mutt.key http://www.mutt.org/brendan.key
tmp_keyring=~/Tmp/keyring.gpg
gpg --no-default-keyring --keyring $tmp_keyring --import mutt.key
gpg --no-default-keyring --keyring $tmp_keyring --verify sig.tar.gz.asc mutt.tar.gz
rm -f $tmp_keyring mutt.key sig.tar.gz.asc

# extract and patch
tar xzf mutt.tar.gz && mv mutt-*/* . && rm -f mutt.tar.gz

wget -O trash.patch http://scie.nti.st/dist/trash-1.5.16.patch
echo 'ed71aee8a637c6327d9e888b1cc9d8f20918b454  trash.patch' | sha1sum --status --check -
patch -p1 < trash.patch

wget -O sidebar.patch https://raw.github.com/nedos/mutt-sidebar-patch/7ba0d8db829fe54c4940a7471ac2ebc2283ecb15/mutt-sidebar.patch
echo '1e151d4ff3ce83d635cf794acf0c781e1b748ff1 sidebar.patch' | sha1sum --status --check -
patch -p1 < sidebar.patch

# build
./configure --enable-pop --enable-imap --enable-smtp --with-ssl --enable-hcache --with-gss --with-sasl
make && sudo make install
