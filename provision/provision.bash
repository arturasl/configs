#!/bin/bash -xe
# vim: foldmethod=marker
# vim: foldmarker={{,}}

apt='sudo apt-get -y'
apti="${apt} install"

# directory structure {{
mkdir -p ~/Builds/ ~/Tmp
mkdir -p ~/Projects/{Professional,Personal,Tmp}
# }}
$apt update
# development {{
$apti build-essential autoconf libncurses5-dev
$apti git subversion mercurial # version control
$apti exuberant-ctags          # generates tag file for pretty much every language
$apti xdotool xautomation      # x automation tools (particularly cool is xte for mouse and keyboard stuff)
## language specific {{
$apti python{,3}{,-pip}        # python
$apti fpc                      # pascal
$apti openjdk-{6,7}-jdk        # java
$apti nodejs npm \
	&& sudo npm install -g jslint csslint uglifycss uglify-js # javascript
$apti texlive-full             # latex
$apti valgrind astyle cppcheck # c
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
## }}
# }}
# terminal tools {{
## utilities {{
$apti curl xsel xclip
$apti highlight caca-utils w3m-img
$apti graphviz     # graph drawing utility
$apti imagemagick  # converts between various image formats (screen capture, filters, etc.)
$apti pandoc       # converts between various document formats (mkd, latex, rst, etc.)
$apti sshfs curlftpfs # fuse
## }}
## general programs {{
./build/st.bash    # terminal emulator
$apti tmux         # multiplexer
./build/fish.bash  #shell
$apti vim-gtk      # editor
$apti newsbeuter   # news aggregator (rss/atom)
$apti vifm ranger  # file manager
./build/mutt.bash  # mail reader
$apti mosh         # somewhat more persistent ssh
$apti htop         # process monitor
## }}
# }}
# user level programs {{
## general {{
$apti keepassx            # password manager
$apti dropbox             # simple file syncing
$apti skype               # dont ask
$apti chromium-browser opera # internet browser
./build/firefox.bash
$apti libreoffice         # document editor
## }}
## multimedia  {{
$apti gimp                # image editor
$apti inkscape            # vector graphics editor
$apti mplayer             # audio/video player
$apti pitivi              # video editor
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
sudo dpkg-divert  --rename --add /etc/init/gdm.conf # disable gdm
## }}
## fonts {{
$apti ttf-mscorefonts-installer
$apti xfonts-terminus console-terminus
$apti ttf-dejavu fonts-droid
./build/palemonas.bash
## }}
#  }}
