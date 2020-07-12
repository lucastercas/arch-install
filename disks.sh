#!/bin/bash

read -p "Disk: " disk

mkfs.fat -F32 "/dev/${disk}1"
mkfs.ext4 "/dev/${disk}2"
mkfs.ext4 "/dev/${disk}3"

mount "/dev/${disk}2" /mnt

mkdir -p /mnt/efi
mount "/dev/${disk}1" /mnt/efi

mkdir -p /mnt/home
mount "/dev/${disk}3" /mnt/home