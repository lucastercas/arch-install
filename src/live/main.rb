#!/usr/bin/ruby

require_relative('../lib')
require_relative('disks')

def setup_live(config)
  puts("#=== setting up live system ===#")
  system("lsblk")
  setup_disks(config['disks'])
  system("pacstrap -i /mnt base base-devel")
  system("genfstab -U /mnt >> /mnt/etc/fstab")
end

def setup_disks(disks)
  puts("#--- setting disks ---#")
  disks.each do |disk|
    puts("==> Setting up disk #{disk[0]}")
    print("Format disk #{disk[0]} [y/n]")?
    opt = gets().chomp()
    if opt == "y" then
      system("sgdisk -o /dev/#{disk[0]}")
    end
    create_partitions(disk[0], disk[1])
    mount_partitions(disk[0], disk[1])
    format_partitions(disk[0], disk[1])
  end
end
