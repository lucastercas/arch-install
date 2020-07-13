#!/bin/bash

set -eu

#echo "#--- Install YAY ---#"
#yay_url="https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz"
#curl ${yay_url} | tar -xzv; cd yay && makepkg -si

echo "#--- Install AUR Packages ---"
aur_pkgs_file="./packages/aur.txt"
packages=""
while IFS= read -r line; do
  packages="${packages} ${line}"
done < "$aur_pkgs_file"
yay --noconfirm -S "${packages}"
