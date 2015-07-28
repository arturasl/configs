#!/bin/bash -xe
# vim: foldmethod=marker
# vim: foldmarker={{,}}

apt='sudo apt-get -y'
apti="${apt} install"
mkdir -p ~/Builds/ ~/Tmp

$apt update

# development {{
$apti build-essential autoconf libncurses5-dev
$apti git subversion mercurial # version controll
$apti exuberant-ctags          # generates tag file for pretty much every language
## language specifc {{
$apti python{,3}{,-pip}        # python
$apti fpc                      # pascal
$apti openjdk-{6,7}-jre        # java
$apti nodejs npm \
	&& sudo npm install -g jslint csslint uglifycss uglify-js # javascript
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
## }}
## general programs {{
./build/st.bash    # terminal emulator
$apti tmux         # multiplexer
./build/fish.bash  #shell
$apti vim-gtk      # editor
$apti newsbeuter   # news aggregator (rss/atom)
$apti vifm ranger  # file manager
$apti mutt         # mail reader
$apti mosh         # somewhat more persistant ssh
$apti htop         # process monitor
## }}
# }}
# user level programs {{
## general {{
$apti keepassx            # password manager
$apti dropbox             # simple file syncing
$apti firefox             # internet browser

mkdir -p ~/Tmp/firefoxaddons && cd ~/Tmp/firefoxaddons
for addon in "298890/vimperator-3.9-fx"; do
	wget "https://addons.mozilla.org/firefox/downloads/file/${addon}.xpi"
done
firefox *.xpi
cd

$apti libreoffice         # document editor
$apti feh                 # image previewing
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
$apti i3lock              # screen locker
echo -e '#!/bin/bash\ni3lock -c 000000' | sudo tee /usr/local/bin/lock && sudo chmod a+x /usr/local/bin/lock
$apti dmenu               # general menu (using for program selection)
## }}
#  }}
