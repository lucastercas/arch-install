#!/usr/bin/ruby

def user()
  puts("#--- creating user ---#")
  
  print("Username: ")
  username = gets().chomp()
  print("Name: ")
  name = gets().chomp()

  system("arch-chroot /mnt useradd -m -G wheel,docker -s /bin/zsh -c \"#{name}\" #{username}")
  system("arch-chroot /mnt passwd #{username}")
  system("arch-chroot /mnt visudo")

  install_git = "https://github.com/lucastercas/arch-install"
  system("arch-chroot /mnt git clone #{install_git} /home/#{username}/arch-install")
  system("arch-chroot /mnt chown -R #{username}:#{username} /home/#{username}")
end