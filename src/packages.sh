#!/usr/bin/env bash

# $1 -> Path to file that contains the package list
install_packages() {
  packages=""
  while IFS= read -r line; do
    packages="${packages} ${line}"
  done < "$1"
  exec_chroot_cmd "pacman -S --noconfirm $packages"
}

set_mirrors() {
  $1 "pacman -S pacman-contrib"
  $1" curl -s
  'https://www.archlinux.org/mirrorlist/?country=BR&protocol=http&protocol=https&ip_version=4&use_mirror_status=on'
  | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - >
  /etc/pacman.d/mirrorlist"
  $1 "pacman-key --init"
  $1 "pacman-key --populate archlinux"
  $1 "pacman -Sy"
}

