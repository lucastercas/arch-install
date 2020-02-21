#!/usr/bin/env ruby

# Author: Lucas de Macedo
# Github: lucastercas

require './src/setup_disk.rb'
require './src/setup_pacstrap.rb'
require './src/genfstab.rb'
require './src/chroot.rb'

def main()
  while true do
    puts "===== Welcome to the Arch Installation ====="
    puts "1 - Setup Disk"
    puts "2 - Pacstrap"
    puts "3 - Generate fstab"
    puts "4 - Chroot Options"
    puts "8 - Exit"
    option = gets.chomp.to_i
    case option
      when 1
        configureDiskMenu()
      when 2
        setupPacstrap()
      when 3
        genfstab()
      when 4
        chrootOptionsMenu()
      when 0
        break
    end
  end
end

main()
