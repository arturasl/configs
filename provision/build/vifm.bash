#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail
shopt -s failglob

git-get() {
    local from="$1"
    local to="$2"

    mkdir -p "$to"

    if [[ -n "$(ls "$to")" ]]; then
        (cd "$to" && git pull)
        return
    fi

    git clone "$from" "$to"
}

install() {
    sudo pacman -S --noconfirm "$@"
}

main() {
    local build_dir="${HOME}/Builds/vifm"
    rm -rf "${build_dir}" && mkdir -p "${build_dir}" && cd "${build_dir}"

    git-get https://github.com/vifm/vifm.git .
    ./configure && make && sudo make install

    # color schemes
    rm -rf ~/.vifm/colors/
    mkdir -p ~/.vifm/colors
    git-get https://github.com/vifm/vifm-colors.git ~/.vifm/colors

    # for previewing
    install python-pygments
    install docx2txt antiword odt2txt
    install mediainfo
}

main "$@"
