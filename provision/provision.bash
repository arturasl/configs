#!/bin/bash -xe
# vim: foldmethod=marker
# vim: foldmarker={{,}}

apt='sudo apt-get -y'
apti="${apt} install"
aptr() {
	sudo add-apt-repository -y "ppa:$1"
	shift 1
	$apt update && $apti "$@"
}
pip='~/configs/scripts/global/syspip3 install --user'

# directory structure {{
mkdir -p ~/Builds/ ~/Tmp
mkdir -p ~/Projects/{Professional,Personal,Tmp}
# }}
$apt update
# development {{
$apti build-essential autoconf libncurses5-dev cmake
$apti git subversion mercurial # version control
$apti exuberant-ctags          # generates tag file for pretty much every language
$apti xdotool xautomation      # x automation tools (particularly cool is xte for mouse and keyboard stuff)
aptr zeal-developers/ppa zeal
sudo apt-get install libxml2-dev libxslt1-dev
$pip doc2dash

## language specific {{
$apti python{,3}{,-pip}        # python
$apti fpc                      # pascal
$apti openjdk-{6,7}-jdk maven ant # java
aptr openjdk-r/ppa openjdk-8-jdk
# use java8 by default
sudo update-java-alternatives -s "$(update-java-alternatives -l | awk '{print $3}' | grep 1.8 | grep jdk | head -n 1)"
$apti nodejs npm \
	&& sudo npm install -g jslint csslint uglifycss uglify-js # javascript
$apti texlive-full             # latex
$apti astyle cppcheck libboost-all-dev  # c
curl https://sh.rustup.rs -sSf | sh # rust
rustup install nightly
rustup run nightly cargo install rustfmt-nightly # autoformat
rustup component add rust-src && rustup run stable cargo install racer # autocompletion
$apti golang                   # go
### language servers {{
$apti clang
$pip python-language-server
$pip language-check
### }}
## }}
## idea {{
$apti geany
$apti code{blocks,lite}
./build/intellij.bash
./build/dbeaver.bash
## }}
## virtual machines {{
$apti linux-{,image-}generic linux-{signed,headers}-generic
$apti dkms virtualbox{,-dkms,-qt} qemu
$apti vagrant
$apti docker.io vim-syntax-docker
## }}
## debugging {{
$apti wireshark                # network traffic analyzer
./build/afl.bash               # fuzzier
$apti valgrind                 # memory debugger
## }}
# }}
# terminal tools {{
## utilities {{
$apti curl
$apti xsel xclip   # clipboard manipulation
$apti arandr       # managing monitor positions
$apti highlight caca-utils w3m-img
$apti graphviz     # graph drawing utility
$apti imagemagick  # converts between various image formats (screen capture, filters, etc.)
$apti pandoc       # converts between various document formats (mkd, latex, rst, etc.)
$apti sshfs curlftpfs # fuse
$apti moreutils    # various small utils like sponge
$apti dnsutils
$apti time         # /usr/bin/time
## }}
## general programs {{
./build/st.bash    # terminal emulator
$apti tmux         # multiplexer
./build/fish.bash  #shell
$apti vim-gtk      # editor
$apti newsboat     # news aggregator (rss/atom)
$apti ranger       # file manager
./build/vifm.bash  # file manager
./build/mutt.bash  # mail reader
$apti mosh         # somewhat more persistent ssh
$apti htop         # process monitor
## }}
# }}
# security {{
$apti keepassx                 # password manager
## gnome keyring {{
$apti gnome-keyring            # daemon for handling sensitive information
$apti libgnome-keyring-{common,dev}     # library which is used by third party software to interact with gnome-keyring
$apti seahorse                 # gui to gnome keyring
$apti secret-tools             # cli to gnome keyring
./build/git-gnome-keyring.bash # integrates gnome-keyring with git
## }}
# }}
# user level programs {{
## general {{
$apti dropbox             # simple file syncing
$apti skype               # dont ask
$pip hangups # dont ask
$apti chromium-browser opera # internet browser
./build/firefox.bash
$apti libreoffice         # document editor
## }}
## multimedia  {{
$apti gimp                # image editor
$apti inkscape            # vector graphics editor
$apti mplayer             # audio/video player
$apti pitivi              # video editor
$apti audacity            # audio recording/editing
## }}
## document viewers {{
$apti zathura{,-djvu,-ps} # document preview (pdf, djvu, ps)
$apti calibre             # epub reader/converter
## }}
## window manager{{
./build/dwm/dwm.bash
./build/i3lock.bash       # screen locker
$apti dmenu               # general menu (using for program selection)
$apti trayer              # tray
$apti dzen2               # top panel
$apti feh                 # image previewing
$apti conky               # shows various information about system
$apti xbacklight          # allows to change brightness
$apti xsetroot
$apti xfontsel
$apti xinput
$apti redshift            # changes screen color blue->red over the day
sudo dpkg-divert  --rename --add /etc/init/gdm.conf # disable gdm
$pip install python-forecastio
## }}
## fonts {{
$apti ttf-mscorefonts-installer
$apti xfonts-terminus console-terminus
$apti ttf-dejavu fonts-droid
./build/external_fonts.bash
## }}
#  }}
