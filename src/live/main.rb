#!/usr/bin/ruby

require_relative('../lib')
require_relative('disks')

def setup_live(config)
  system("clear")
  puts("#=== setting up live system ===#")
  system("lsblk")
  setup_disks(config['disks'])
  system("pacstrap -i /mnt base base-devel")
  system("genfstab -U /mnt >> /mnt/etc/fstab")
end

def setup_disks(disks)
  puts("#--- setting disks ---#")
  disks.each do |disk|
    puts("==> Setting up disk #{disk['name']}")
    print("Format disk #{disk['name']}? [y/n]")
    opt = gets().chomp()
    system("sgdisk -o /dev/#{disk['name']}") if opt == "y"
    create_partitions(disk)
    format_partitions(disk)
    mount_partitions(disk)
  end
end
