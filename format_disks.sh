#!/bin/bash

set -eu

read -p "Disk: " disk

mkfs.fat -F32 "/dev/${disk}1"
mkfs.ext4 "/dev/${disk}2"
mkfs.ext4 "/dev/${disk}3"
