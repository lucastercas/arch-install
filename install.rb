#!/usr/bin/env ruby

# Author: Lucas de Macedo
# Github: lucastercas

require './setup_disk.rb'

def getOption(question)
  puts "=> #{question} [N]o / [Y]es:"
  option = $stdin.gets.chomp

  if option == 'Y' || option == 'y' then
    return true
  else
    return false
  end
end

def main()
  while true do
    puts "===== Welcome to the Arch Installation ====="
    puts "1 - Setup Disk"
    puts "2 - Pacstrap"
    puts "3 - Generate fstab"
    puts "4 - Chroot Options"
    puts "5 - Exit"
    option = gets.chomp.to_i
    case option
      when 1
        configureDiskMenu()
      when 2
      when 3
      when 4
      when 5
        break
    end
  end
end

main()

# puts "\n### Disk Preparation ###"

#puts  "== Configuring Time and Date =="
#puts "timedatectl set-ntp true"

#puts "== Configuring Keyboard =="
#puts "=> Layout of the keyboard: (ex: br-abnt2)"
#kb_layout = gets.chomp
#kb_layout = 'br-abnt2'
#puts "Configuring Keyboard to #{kb_layout}"
#puts "loadkeys #{kb_layout}"

# puts  "=== Configuring Disk ==="
# puts "=> Disk To Configure: (Ex: /dev/sda)"
# disk = gets.chomp
# configureDisk(disk)

# puts  "=== Configuring Pacstrap =="
# puts "==> pacstrap -i /mnt base-devel"
# system "pacstrap -i /mnt base base-devel ruby"
# puts "==> genfstab -U -p /mnt >> /mnt/etc/fstab"
# system "genfstab -U -p /mnt >> /mnt/etc/fstab"

# puts "=== Copying Installation Script into chroot Env ==="
# system "cp ./install-chroot.rb /mnt/opt/"
# system "cp ./default-packages.txt /mnt/opt/"

# puts "=== Entering chroot Env ==="
# puts "==> arch-chroot /mnt ruby /opt/install-chroot.rb"
# system "arch-chroot /mnt ruby /opt/install-chroot.rb"


