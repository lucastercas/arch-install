# Author: Lucas de Macedo
# Github: lucastercas

# Usage: ./configure-hostname.rb
# Ex: ./configure-hostname

puts "=== Configuring Hostname ==="

puts "Hostname: (Ex: hyperion)"
hostname = $stdin.gets.chomp

system "echo #{hostname} >> /etc/hostname"
