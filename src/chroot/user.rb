#!/usr/bin/ruby

def user()
  puts("#--- creating user ---#")
  
  print("Username: ")
  username = gets().chomp()
  print("Name: ")
  name = gets().chomp()

  system("arch-chroot /mnt useradd -m -G wheel,docker -s /bin/zsh -c #{name} #{username}")
  system("arch-chroot /mnt passwd #{username}")
end
