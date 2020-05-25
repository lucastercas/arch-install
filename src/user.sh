#!/usr/bin/env bash

add_user() {
  read -p "Username: " username
  read -p "Complete Name: " complete_name
  execute_chroot_cmd "useradd -m -G wheel -s /bin/zsh -c $complete_name $username"
  execute_chroot_cmd "passwd $username"
}
