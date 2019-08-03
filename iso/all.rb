#!/usr/bin/env ruby
# Author: Lucas de Macedo
# Github: lucastercas

def get_option(question)
  puts "=> #{question} [N]o / [Y]es:"
  option = $stdin.gets.chomp

  if option == 'Y' || option == 'y' then
    return true
  else
    return false
  end
end

puts "===== Configuring Iso ====="

configure_keyboard = get_option "Configure Keyboard?"
if configure_keyboard then
  load "./configure-keyboard.rb")
end

configure_disk = get_option "Configure Disk and Mounting?"
if configure_disk then
  load "configure-disk.rb"
end

configure_pacstrap = get_option "Configure Pacstrap?"
if configure_pacstrap then
  load "configure-pacstrap.rb"
end

configure_time = get_option "Configure Timedate?"
if configure_time then
  load "configure-timedate.rb"
end
