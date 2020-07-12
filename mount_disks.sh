#!/bin/bash

set -eu

read -p "Disk: " disk

mount "/dev/${disk}2" /mnt

mkdir -p /mnt/efi
mount "/dev/${disk}1" /mnt/efi

mkdir -p /mnt/home
mount "/dev/${disk}3" /mnt/home