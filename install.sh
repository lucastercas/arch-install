#!/usr/bin/env bash

set -e
execute_cmd() {
  echo "==> $1"
  eval "arch-chroot /mnt $1"
}

execute_cmd "runuser -l lucastercas -c 'mkdir -p workspace'"
execute_cmd "runuser -l lucastercas -c 'git clone https://github.com/lucastercas/arch-install workspace/arch-install'"
execute_cmd "runuser -l lucastercas -c './workspace/arch-install/aur.sh'"
