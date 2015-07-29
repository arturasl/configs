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
$apti texlive-full             # latex
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
$apti graphviz     # graph drwing utility
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
$apti mutt         # mail reader
$apti mosh         # somewhat more persistant ssh
$apti htop         # process monitor
## }}
# }}
# user level programs {{
## general {{
$apti keepassx            # password manager
$apti dropbox             # simple file syncing
$apti skype               # dont ask
$apti firefox             # internet browser

mkdir -p ~/Tmp/firefoxaddons && cd ~/Tmp/firefoxaddons
for addon in \
	$(`# Security addons`) \
	$(`## Addblock plus`) "latest/1865/addon-1865-latest.xpi" \
	$(`## Ghostery`) "latest/9609/addon-9609-latest.xpi" \
	$(`## NoScript`) "latest/722/addon-722-latest.xpi" \
	$(`## Duckdukgo search engine`) "latest/252586/addon-252586-latest.xml" \
	$(`# Development addons`) \
	$(`## Firebug`) "latest/1843/addon-1843-latest.xpi" \
	$(`## firepicker (allows to nicelly select colors in firebug)`) "latest/15032/addon-15032-latest.xpi" \
	$(`## JSONView (format application/json documents)`) "latest/10869/addon-10869-latest.xpi" \
	$(`## Tamper Data (intercept http requests)`) "latest/966/addon-966-latest.xpi" \
	$(`## MeasureIt`) "latest/539/addon-539-latest.xpi" \
	$(`# Dictionaries`) \
	$(`## Dictionary popup`) "latest/406852/addon-406852-latest.xpi" \
	$(`## Lithuanian dictionary`) "latest/3716/addon-3716-latest.xpi" \
	$(`## LanguageToolFx – Style and Grammar Checker`) "latest/407110/addon-407110-latest.xpi" \
	$(`# Usability`) \
	$(`## Vimperator`) "file/298890/vimperator-3.9-fx.xpi" \
	$(`## iMacros`) "latest/3863/addon-3863-latest.xpi" \
	$(`## Greasemonkey`) "latest/748/addon-748-latest.xpi" \
	$(`# Other`) \
	$(`## Update Scanner`) "latest/3362/addon-3362-latest.xpi" \
	$(`## Download Helper`) "latest/3006/addon-3006-latest.xpi" \
; do
	wget "https://addons.mozilla.org/firefox/downloads/${addon}"
done
firefox *.xpi
cd

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
$apti i3lock              # screen locker
echo -e '#!/bin/bash\ni3lock -c 000000' | sudo tee /usr/local/bin/lock && sudo chmod a+x /usr/local/bin/lock
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

if [ ! -d /usr/local/share/fonts/truetype/palemonas ]; then
	wget -O palemonas.zip http://www.vlkk.lt/media/public/file/Palemonas/Palemonas-3_0.zip && unzip palemonas.zip && rm -f palemonas.zip
	sudo mkdir -p /usr/local/share/fonts/truetype/palemonas
	sudo cp *alemonas*/*.ttf /usr/local/share/fonts/truetype/palemonas
	rm -rf *alemonas*
fi

sudo fc-cache -fv
## }}
#  }}
