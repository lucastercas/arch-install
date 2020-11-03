#!/usr/bin/ruby

require_relative('src/lib')
require_relative('src/live/main')
require_relative('src/chroot/main')

print_header()

print("config to load: ")
config_file = gets().chomp()
config = read_yaml("configs/systems/#{config_file}.yml")

while true do
  puts("""Choose one:
    1. Live System
    2. Chroot
    3. Exit
  """)
  print("Choice: ")
  opt = gets().chomp()
  case opt.to_i()
  when 1
    setup_live(config)
  when 2
    setup_chroot(config)
  when 3
    break
  end
end
