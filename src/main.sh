#!/bin/bash

. $(pwd)/lib.sh
. $(pwd)/chroot/main.sh

print_header

lsblk

format_disks

mount_disks

pacstrap

genfstab
