#!/bin/bash -xe

FONT_DIR='/usr/local/share/fonts/truetype'

build_dir="${HOME}/Builds/external_fonts"
mkdir -p "${build_dir}"
cd "${build_dir}"

if [ ! -d "${FONT_DIR}/palemonas" ]; then
    if [ ! -f "palemonas.zip" ]; then
        echo "Manually download https://vlkk.lt/media/public/file/Palemonas/Palemonas3.2.05.zip?lang=en"
        exit 1
    fi
    unzip palemonas.zip && rm -f palemonas.zip
	sudo mkdir -p "${FONT_DIR}/palemonas"
	sudo cp ./*alemonas*/*.ttf "${FONT_DIR}/palemonas"
	rm -rf ./*alemonas*
fi

if [ ! -f "${FONT_DIR}/Mywriting.ttf" ]; then
	wget -O mywriting.zip 'http://dl.dafont.com/dl/?f=mywriting' && unzip mywriting.zip && rm -f mywriting.zip
	sudo mv Mywriting.ttf "${FONT_DIR}"
fi

sudo fc-cache -fv
