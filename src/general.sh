#!/bin/bash

# $1 -> Command to execute
execute_chroot_cmd() {
  cmd="arch-chroot /mnt $1"
  echo "$cmd"
  eval "$cmd"
}

# $1 -> Command to execute
execute_cmd() {
  echo "$1"
  eval "$1"
}

execute_as_user() {
  arch-chroot /mnt "runuser -l lucastercas -c '$1'"
}
