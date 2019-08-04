# Author: Lucas de Macedo
# Github: lucastercas

# Usage: ./configure-location.rb <location>
# Ex: ./configure-location.rb pt_BR.UTF-8

puts "=== Configuring Location ==="

puts "Location: (Ex: pt_BR.UTF-8)"
location = $stdin.gets.chomp

system "ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
system "sed -i 's/#{location}/#{location}/' /etc/locale.gen"
system "locale-gen"
system "hwclock --systohc"
system "echo 'LANG=#{location}' >> /etc/locale.conf"
#"echo "KEYMAP=" >> /etc/vconsole.conf"
