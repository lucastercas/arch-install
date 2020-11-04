#!/usr/bin/ruby

def services(services_list)
  puts("#--- enabling services ---#")
  system("arch-chroot /mnt systemctl enable #{services_list}")
end
