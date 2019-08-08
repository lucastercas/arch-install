#!/usr/bin/env ruby
# Author: Lucas de Macedo
# Github: lucastercas

require 'csv'

def getOption(question)
  puts "=> #{question} [N]o / [Y]es:"
  option = $stdin.gets.chomp

  if option == 'Y' || option == 'y' then
    return true
  else
    return false
  end
end

def printPartition(partition)
  puts "Name: #{partition[1]}"
  puts "\tNum: #{partition[0]}"
  puts "\tStart: #{partition[2]}"
  puts "\tEnd: #{partition[3]}"
  puts "\tCode: #{partition[4]}"
end

def createPartition(disk, partition)
    puts "=== Creating partition #{partition[0]} - Size: #{partition[2]} - #{partition[3]} ==="
    puts "==> sgdisk -n #{partition[0]}:#{partition[2]}:#{partition[3]} -c #{partition[0]}:\"#{partition[1]}\" -t #{partition[0]}:#{partition[4]} #{disk}"
    system "sgdisk -n #{partition[0]}:#{partition[2]}:#{partition[3]} -c #{partition[0]}:\"#{partition[1]}\" -t #{partition[0]}:#{partition[4]} #{disk}"
end

def formatPartition(disk, partition)
  volume = "#{disk}#{partition[0]}"
  case partition[4]
  when "ef00"
    puts "==> mkfs.vfat -F32 #{volume}"
    system "mkfs.vfat -F32 #{volume}"
  when "8200"
    puts "==> mkswap #{volume}"
    system "mkswap #{volume}"
    puts "==> swapon #{volume}"
    system "swapon #{volume}"
  when "8300"
    puts "==> mkfs.ext4 #{volume}"
    system "mkfs.ext4 #{volume}"
  when "8302"
    puts "==> mkfs.ext4 #{volume}"
    system "mkfs.ext4 #{volume}"
  else
    puts "Code #{partition[4]} not recognized"
  end
end

def mountPartition(disk, partition)
  puts "=== Mounting Partiton #{partition[1]}"
  puts "==> mkdir -p /mnt#{partition[5]}"
  system "mkdir -p /mnt#{partition[5]}"
  puts "==> mount #{disk}#{partition[0]} /mnt#{partition[5]}"
  system "mount #{disk}#{partition[0]} /mnt#{partition[5]}"
end

def configureDisk(disk)
  puts "Clearing disk #{disk}"
  system "sgdisk -oZg #{disk}"

  partitions = CSV.read('partitions.csv')

  partitions.each.with_index do |partition, index|
    if index == 0 then next end
    printPartition(partition)
    createPartition(disk, partition)
    formatPartition(disk, partition)
  end
  mountPartition(disk, partitions[2])
  mountPartition(disk, partitions[1])
  mountPartition(disk, partitions[3])
end

puts "##### Arch Install #####"

puts "\n### Disk Preparation ###"

#puts  "== Configuring Time and Date =="
#puts "timedatectl set-ntp true"

#puts "== Configuring Keyboard =="
#puts "=> Layout of the keyboard: (ex: br-abnt2)"
#kb_layout = gets.chomp
#kb_layout = 'br-abnt2'
#puts "Configuring Keyboard to #{kb_layout}"
#puts "loadkeys #{kb_layout}"

puts  "=== Configuring Disk ==="
puts "=> Disk To Configure: (Ex: /dev/sda)"
disk = gets.chomp
configureDisk(disk)

puts  "=== Configuring Pacstrap =="
puts "==> pacstrap -i /mnt base-devel"
system "pacstrap -i /mnt base base-devel ruby"
puts "==> genfstab -U -p /mnt >> /mnt/etc/fstab"
system "genfstab -U -p /mnt >> /mnt/etc/fstab"

puts "=== Copying Installation Script into chroot Env ==="
system "cp ./install-chroot.rb /mnt/opt/"
system "cp ./default-packages.txt /mnt/opt/"

puts "=== Entering chroot Env ==="
puts "==> arch-chroot /mnt ruby /opt/install-chroot.rb"
system "arch-chroot /mnt ruby /opt/install-chroot.rb"


