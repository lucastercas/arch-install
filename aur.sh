#!/usr/bin/env bash

printf "\n##### YAY #####\n"
curl https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz | tar xzv
(cd yay && makepkg -si)

aur_pkgs_file="./packages/aur.txt"
packages=""
while IFS= read -r line; do
  packages="${packages} ${line}"
done < "$aur_pkgs_file"
cmd="yay -S $packages"
echo "==> $cmd"; eval "$cmd"
