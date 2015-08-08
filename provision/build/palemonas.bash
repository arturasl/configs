#!/bin/bash -xe

if [ ! -d /usr/local/share/fonts/truetype/palemonas ]; then
	wget -O palemonas.zip http://www.vlkk.lt/media/public/file/Palemonas/Palemonas-3_0.zip && unzip palemonas.zip && rm -f palemonas.zip
	sudo mkdir -p /usr/local/share/fonts/truetype/palemonas
	sudo cp *alemonas*/*.ttf /usr/local/share/fonts/truetype/palemonas
	rm -rf *alemonas*
	sudo fc-cache -fv
fi
