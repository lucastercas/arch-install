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
    puts "sgdisk -n #{partition[0]}:#{partition[2]}:#{partition[3]} -c #{partition[0]}:\"#{partition[1]}\" -t #{partition[0]}:#{partition[4]} #{disk}"
end

def formatPartition(disk, partition)
  volume = "#{disk}#{partition[0]}"
  case partition[4]
  when "ef00"
    puts "mkfs.vfat -F32 #{volume}"
  when "8200"
    puts "mkswap #{volume}"
    puts "swapon #{volume}"
  when "8300"
    puts "mkfs.ext4 #{volume}"
  when "8302"
    puts "mkfs.ext4 #{volume}"
  else
    puts "Code #{partition[4]} not recognized"
  end
end

def mountPartition(disk, partition)
  puts "=== Mounting Partiton #{partition[1]}"
  puts "mkdir -p /mnt#{partition[5]}"
  puts "mount #{disk}#{partition[0]} /mnt#{partition[5]}"
end

def configureDisk(disk)
  puts "Clearing disk #{disk}"
  puts "sgdisk -oZg #{disk}"

  partitions = CSV.read('partitions.csv')

  partitions.each do |partition|
    printPartition(partition)
    createPartition(disk, partition)
    formatPartition(disk, partition)
  end
  mountPartition(disk, partitions[2])
  mountPartition(disk, partitions[1])
  mountPartition(disk, partitions[3])

end

def getPackagesFromFile(file)
  packages_file = File.open(file)
  packages = []
  packages_file.each_line do |line|
    if line[0] != '#' then
      packages.append(line.gsub("\n", ''))
    end
  end
  packages = packages.join(' ')
  return packages
end

puts "##### Arch Install #####"

puts "\n### Disk Preparation ###"

puts  "== Configuring Time and Date =="
puts "timedatectl set-ntp true"

puts "== Configuring Keyboard =="
puts "=> Layout of the keyboard: (ex: br-abnt2)"
#kb_layout = gets.chomp
kb_layout = 'br-abnt2'
puts "Configuring Keyboard to #{kb_layout}"
puts "loadkeys #{kb_layout}"

puts  "== Configuring Disk =="
puts "=> Disk To Configure: (Ex: /dev/sda)"
#disk = gets.chomp
disk = '/dev/sda'
configureDisk(disk)

puts  "== Configuring Pacstrap =="
puts "pacstrap -i /mnt base-devel"
puts "genfstab -U -p /mnt >> /mnt/etc/fstab"

puts "\n### chroot ###"
chroot_cmd = "arch-chroot /mnt"

puts "=== Configuring Locale ==="
puts "#{chroot_cmd} ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
puts "#{chroot_cmd} sed -i 's/pt_BR.UTF-8/pt_BR.UTF-8/' /etc/locale.gen"
puts "#{chroot_cmd} locale-gen"
puts "#{chroot_cmd} hwclock --systohc"
puts "#{chroot_cmd} echo 'LANG=pt_BR.UTF-8' >> /etc/locale.conf"

puts "=== Installing Additional Packages ==="
default_packages = getPackagesFromFile('default-packages.txt')
puts "#{chroot_cmd} pacman -S #{default_packages}"

puts "=== Configuring Hostname ==="
puts "Hostname: "
#hostname = gets.chomp
hostname = "hyperion"
puts "#{chroot_cmd} echo #{hostname} >> /etc/hostname"

puts "#{chroot_cmd} mkinitcpio -p linux"

puts "#{chroot_cmd} passwd"

puts "=== Configuring BootLoader (rEFInd) ==="
puts "#{chroot_cmd} refind-install"

puts "=== Configuring User ==="
puts "User: "
username = gets.chomp
puts "#{chroot_cmd} useradd -m -G wheel -s /bin/zsh -c 'Lucas Tercas' #{username}"
puts "#{chroot_cmd} passwd #{username}"
