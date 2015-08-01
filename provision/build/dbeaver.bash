#!/bin/bash -xe

mkdir ~/Builds/dbeaver && cd ~/Builds/dbeaver
wget -O dbeaver.zip http://dbeaver.jkiss.org/files/dbeaver-3.4.4-linux.gtk.x86_64.zip
echo '0cf0aa61a3b3a7e35edc68caca21b66a8596fe10  dbeaver.zip' | sha1sum --status --check -
unzip dbeaver.zip && rm -f dbeaver.zip && mv dbeaver a && mv a/* . && rm -r a
sudo ln -s "$(pwd)/dbeaver" /usr/bin/dbeaver
