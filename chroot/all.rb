# Author: Lucas de Macedo
# Github: lucastercas

def get_option(question)
  puts "#{question} [Y]es / [N]o"
  option = $stdin.gets.chomp
  if option == 'Y' || option == 'y' then
    return true
  else
    return false
  end
end

puts "===== Configuring System ====="

location = get_option("Configure Location?")
if location then
  load "configure-location.rb"
end

grub = get_option "Configure Grub?"
if grub then
  load "configure-grub.rb"
end

hostname = get_option "Configure Hostname?"
if hostname then
  load "configure-hostname.rb"
end

user = get_option "Configure User?"
if user then
  load "configure-user.rb"
end

root = get_option "Configure Root?"
if root then
  load "configure-root.rb"
end
