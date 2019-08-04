#!/usr/bin/env ruby

# Author: Lucas de Macedo
# Github: lucastercas

# Usage: ./configure-disk.rb
# Ex: ./configure-disk.rb

def clear_disk(disk)
  puts "Clearing disk #{disk}"
  puts "sgdisk -oZg #{disk}"
end

def get_partition(num, disk)
  partition = {
    num: "",
    name: "",
    start: "",
    end: "",
    code: ""
  }

  puts "=> Name of partition: "
  partition[:name] = $stdin.gets.chomp

  puts "=> Size of partition: Ex: (+XXGib +YYMiB)"
  partition[:start] = $stdin.gets.chomp

  puts "efi -> ef00\nroot->8300\nswap->8200\nlinux->8302"
  puts "=> Code of partition: "
  partition[:code] = $stdin.gets.chomp

  partition[:end] = 0
  partition[:num] = num
  partition[:disk] = disk

  return partition
end

# TODO: Different format type for different partition types
def format_partition(disk, partition)
  case partition[:code]
  when "ef00"
    puts "Formatting EFI -> #{disk}/#{partiton[:num]}"
    puts "mkfs.vfat -F32 #{disk}/#{partiton[:num]}"
  when "8300"
    puts "Formating ROOT -> #{disk}/#{partition[:code]}"
    puts "mkfs.ext4 #{disk}/#{partition[:code]}"
  when "8200"
    puts "Formating SWAP -> #{disk}/#{partition[:code]}"
    puts "mkswap #{disk}/#{partition[:code]}"
    puts "swapon #{disk}/#{partition[:code]}"
  when "8302"
    puts "Formating LINUX -> /#{partition[:code]}"
    puts "mkfs.ext4 #{disk}/#{partition[:code]}"
  else
    puts "Code not recognized"
  end
end

def create_partition(disk, partition)
    puts "Creating partition #{partition[:name]} - Size: #{partition[:end]}"
    system "sgdisk -n #{partition[:num]}:#{partition[:start]}:#{partition[:end]} -c #{partition[:num]}:\"#{partition[:name]}\" -t #{partition[:num]}:#{partition[:code]} #{partition[:disk]}"
end

def print_partition(partition)
  puts "Name: #{partition[:name]}"
  puts "\tNumber: #{partition[:num]}"
  puts "\tStart: #{partition[:start]}"
  puts "\tEnd: #{partition[:end]}"
  puts "\tCode: #{partition[:code]}"
end

def configure_disk(disk)

  partitions = []

  num = 0
  while true do
    new_partition = get_partition(num, disk)

    while true do
      print_partition(new_partition)
      puts "=> Is this correct? [N]o / [Y]es:"
      option_correct = $stdin.gets.chomp
      if option_correct == 'Y' || option_correct == 'y' then
        break
      end
      new_partition = get_partition(num, disk)
    end
    partitions.push(new_partition)
    num = num + 1

    puts "=> Create another partition? [Y]es / [N]o:"
    option = $stdin.gets.chomp
    if option == 'n' || option == 'N' then
      break
    end

  end

  partitions.each do |part|
    create_partition(disk, part)
    format_partition(disk, part)
  end

end

puts "===== Configuring Disks ====="

puts "=> Disk To Configure: (Ex: /dev/sda)"
disk = $stdin.gets.chomp
configure_disk(disk)
