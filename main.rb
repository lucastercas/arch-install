#!/usr/bin/ruby

require_relative 'src/lib'
require_relative 'src/live/main'
require_relative 'src/chroot/main'

print_header()
system("lsblk")
setup_disk(disks)

print("config to load: ")
config = gets().chomp()
config = read_yaml("system/#{config}.yml")

setup_disks(config['disks'])
system("pacstrap -i /mnt base base-devel")
system("genfstab -U /mnt >> /mnt/etc/fstab")

set_locale()
set_mirrors()
install_packages(config["packages"]["base"].keys)
install_packages(config["packages"]["graphical"].keys)

system("arch-chroot /mnt mkinitcpio -p linux")

create_user()

puts("#--- root password ---#")
system("arch-chroot /mnt passwd")

puts("#--- hostname ---#")
print("Hostname: ")
hostname = gets().chomp()
system("arch-chroot /mnt echo #{hostname} >> /etc/hostname")

puts("#--- bootloader ---#")
system("arch-chroot /mnt refind-install")

enable_services()