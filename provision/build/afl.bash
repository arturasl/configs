#!/bin/bash -xe

mkdir -p ~/Builds/afl && cd ~/Builds/afl
wget -O afl.tar.gz http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
echo 'be0c54d993512905c328586e575f28d86425567d  afl.tar.gz' | sha1sum --status --check -
tar xzf afl.tar.gz && mv afl-*/* . && rm -f afl.tar.gz
make && sudo make install
