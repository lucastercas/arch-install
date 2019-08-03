# Author: Lucas de Macedo
# Github: lucastercas

# Usage: ./configure-mounting.rb <disk>
# Ex: ./configure-mounting.rb /dev/sda

puts "=== Configuring Disk ==="
disk = ARGV[0]

system("mount #{disk}2 /mnt")

system("mkdir -p /mnt/home")
system("mount #{disk}4 /mnt/home")

system("mkdir -p /mnt/boot")
system("mkdir -p /mnt/boot/efi")
system("mount #{disk}1 /mnt/boot/efi")
