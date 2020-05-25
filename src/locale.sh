#!/usr/bin/env bash

set_locale() {
  exec_chroot_cmd "ln -sf /usr/share/zoneinfo/Brazil/DeNoronha /etc/localtime"
  exec_chroot_cmd "sed -i s/#pt_BR.UTF-8/pt_BR.UTF-8/ /etc/locale.gen"
  exec_chroot_cmd "locale-gen"
  exec_chroot_cmd "hwclock --systohc"
  exec_chroot_cmd "echo LANG=pt_BR.UTF-8 >> /etc/locale.conf"
}
