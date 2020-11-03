#!/usr/bin/ruby

def create_partitions(disk)
  puts("#--- creating partitions for #{disk['name']}")
  disk['partitions'].sort_by{ |w| w['number']}.each do |partition|
    number = partition['number']
    system("sgdisk -n #{number}:0:+#{partition['size']} -c #{number}:#{partition['name']} -t #{number}:#{partition['partition_type']} /dev/#{disk['name']}")
  end
end

def format_partitions(disk)
  puts("#--- formating partitions for #{disk['name']}")
  disk["partitions"].each do |partition|
    puts("--> Formating partition #{partition['number']}")
    case partition["fs_type"]
    when "ext4"
      system("mkfs.ext4 /dev/#{disk['name']}#{partition['number']}")
    when "fat32"
      system("mkfs.fat -F32 /dev/#{disk['name']}#{partition['number']}")
    end
  end
end

def mount_partitions(disk)
  puts("#--- mounting partitions for #{disk['name']}")
  disk["partitions"].each do |partition|
    puts("--> Mounting partition #{partition['number']}")
    system("mkdir -p /mnt/#{partition['mount_point']}")
    system("mount /dev/#{disk['name']}#{partition['number']} /mnt#{partition['mount_point']}")
  end
end