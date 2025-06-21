#!/bin/bash -xe
# vim: foldmethod=marker
# vim: foldmarker={{,}}

build_dir="${HOME}/Builds/alacritty"
rm -rf "${build_dir}"
mkdir -p "${build_dir}"
cd "${build_dir}"

sudo pacman --noconfirm -S alacritty

# Make sure config exists {{
CONFIG_FILE="${HOME}/.config/alacritty/alacritty.toml"
mkdir -p  "$(dirname "$CONFIG_FILE")"
touch "$CONFIG_FILE"
# }}

# Theme (dracula) {{
wget https://github.com/dracula/alacritty/archive/master.zip
unzip master.zip
rm master.zip
mv alacritty-master dracula

sed -i '/dracula/d' "$CONFIG_FILE"
echo "general.import = [\"${build_dir}/dracula/dracula.toml\"]" >> "$CONFIG_FILE"
# }}

# Font {{
sed -i '/font.size/d' "$CONFIG_FILE"
echo "font.size=10" >> "$CONFIG_FILE"

sed -i '/font.normal/d' "$CONFIG_FILE"
echo "font.normal = { family = \"DejaVuSansM Nerd Font Mono\", style = \"Regular\" }" >> "$CONFIG_FILE"
# }}
