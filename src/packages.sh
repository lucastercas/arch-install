#!/bin/bash

# $1 -> Path to file that contains the package list
install_packages() {
    packages=""
    while IFS= read -r line; do
        packages="${packages} ${line}"
    done < "$1"
    exec_chroot_cmd "pacman -S --noconfirm $packages"
}

set_mirrors() {
    exec_chroot_cmd "pacman -S pacman-contrib"
    exec_chroot_cmd "curl -s
    'https://www.archlinux.org/mirrorlist/?country=BR&protocol=http&protocol=https&ip_version=4&use_mirror_status=on'
    | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - >
    /etc/pacman.d/mirrorlist"
    exec_chroot_cmd "pacman-key --init"
    exec_chroot_cmd "pacman-key --populate archlinux"
    exec_chroot_cmd "pacman -Sy"
}
