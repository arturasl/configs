#!/bin/bash -xe

FONT_DIR='/usr/local/share/fonts/truetype'
CHANGED=0

if [ ! -d "${FONT_DIR}/palemonas" ]; then
	wget -O palemonas.zip http://www.vlkk.lt/media/public/file/Palemonas/Palemonas-3_0.zip && unzip palemonas.zip && rm -f palemonas.zip
	sudo mkdir -p "${FONT_DIR}/palemonas"
	sudo cp *alemonas*/*.ttf "${FONT_DIR}/palemonas"
	rm -rf *alemonas*
	CHANGED=1
fi

if [ ! -f "${FONT_DIR}/Mywriting.ttf" ]; then
	wget -O mywriting.zip 'http://dl.dafont.com/dl/?f=mywriting' && unzip mywriting.zip && rm -f mywriting.zip
	sudo mv Mywriting.ttf "${FONT_DIR}"
	CHANGED=1
fi

[ "$CHANGED" -eq 1 ] && sudo fc-cache -fv
