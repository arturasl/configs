#!/bin/bash -xe

build_dir="${HOME}/Builds/alacritty_colors"
rm -rf "${build_dir}"
mkdir -p "${build_dir}"
cd "${build_dir}"

wget https://github.com/dracula/alacritty/archive/master.zip
unzip master.zip
rm master.zip
mv alacritty-master dracula

mkdir -p  ~/.config/alacritty/
touch ~/.config/alacritty/alacritty.toml
sed -i '/alacritty_colors/d' ~/.config/alacritty/alacritty.toml
echo "general.import = [\"${build_dir}/dracula/dracula.toml\"]" >> ~/.config/alacritty/alacritty.toml
