#!/usr/bin/env ruby
# Author: Lucas de Macedo
# Github: lucastercas

# Usage: ./configure-pacstrap.rb

system "pacstrap -i /mnt base base-devel"
system "genfstab -U -p /mnt >> /mnt/etc/fstab"
