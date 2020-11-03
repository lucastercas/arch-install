#!/usr/bin/ruby

def format_partitions(disk_name, partitions)
  partitions["partitions"].each do |partition|
    puts("--> Formating partition #{partition['number']}")
    case partition["type"]
    when "ext4"
      puts("mkfs.ext4 /dev/#{disk_name}#{partition['number']}")
    when "fat32"
      puts("mkfs.fat -F32 /dev/#{disk_name}#{partition['number']}")
    end
  end
end

def mount_partitions(disk_name, partitions)
  partitions["partitions"].each do |partition|
    puts("--> Mounting partition #{partition['number']}")
    puts("mkdir -p /mnt/#{partition['mount_point']}")
    puts("mount /dev/#{disk_name}#{partition['number']} /mnt#{partition['mount_point']}")
  end
end