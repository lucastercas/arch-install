#!/usr/bin/env bash

exec_chroot_cmd() {
  cmd="arch-chroot /mnt $1"
  echo "$cmd"
  eval "$cmd"
}

exec_cmd() {
  echo "$1"
  eval "$1"
}
