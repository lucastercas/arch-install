#!/usr/bin/ruby

def create_partitions(disk_name, disk)
  disk['partitions'].each do |partition|
    number = partition['number']
    system("sgdisk -n #{number}:0:+#{partition['size']} #{number}:#{partition['name']} -t #{number}:#{partition['partition_type']} /dev/#{disk_name}#{number}")
  end
end

def format_partitions(disk_name, disk)
  disk["partitions"].each do |partition|
    puts("--> Formating partition #{partition['number']}")
    case partition["fs_type"]
    when "ext4"
      system("mkfs.ext4 /dev/#{disk_name}#{partition['number']}")
    when "fat32"
      system("mkfs.fat -F32 /dev/#{disk_name}#{partition['number']}")
    end
  end
end

def mount_partitions(disk_name, disk)
  disk["partitions"].each do |partition|
    puts("--> Mounting partition #{partition['number']}")
    system("mkdir -p /mnt/#{partition['mount_point']}")
    system("mount /dev/#{disk_name}#{partition['number']} /mnt#{partition['mount_point']}")
  end
end