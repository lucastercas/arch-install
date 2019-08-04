# Author: Lucas de Macedo
# Github: lucastercas

# Usage: ./configure-user.rb
# Ex: ./configure-user.rb

puts "=== Configuring User ==="

puts "Username:"
username = $stdin.gets.chomp

#"visudo"
# Delete wheel all line
# TODO: Automate this with awk?

system "useradd -m #{username} -G wheel"
system "passwd #{username}"
