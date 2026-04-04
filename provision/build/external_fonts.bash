#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail
shopt -s failglob

main() {
    local font_dir='/usr/local/share/fonts/truetype'

    local build_dir="${HOME}/Builds/external_fonts"
    mkdir -p "${build_dir}"
    cd "${build_dir}"

    if [ ! -d "${font_dir}/palemonas" ]; then
        if [ ! -f "palemonas.zip" ]; then
            echo "Manually download https://vlkk.lt/media/public/file/Palemonas/Palemonas3.2.05.zip?lang=en"
            exit 1
        fi
        unzip palemonas.zip && rm -f palemonas.zip
        sudo mkdir -p "${font_dir}/palemonas"
        sudo cp ./*alemonas*/*.ttf "${font_dir}/palemonas"
        rm -rf ./*alemonas*
    fi

    if [ ! -f "${font_dir}/Mywriting.ttf" ]; then
        wget -O mywriting.zip 'http://dl.dafont.com/dl/?f=mywriting'
        unzip mywriting.zip
        rm -f mywriting.zip
        sudo mv Mywriting.ttf "${font_dir}"
    fi

    sudo fc-cache -fv
}

main "$@"
