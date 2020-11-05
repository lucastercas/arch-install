#!/usr/bin/ruby

def user()
  puts("#--- creating user ---#")
  
  print("Username: ")
  username = gets().chomp()
  print("Name: ")
  name = gets().chomp()

  groups = "wheel,docker,video"
  shell = "/bin/zsh"
  system("arch-chroot /mnt useradd -m -G #{groups} -s #{shell} -c \"#{name}\" #{username}")
  system("arch-chroot /mnt passwd #{username}")
  system("arch-chroot /mnt visudo")

  puts("#--- cloning arch install to system ---#")
  system("arch-chroot /mnt mkdir -p /home/#{username}/workspace/personal")
  install_git = "https://github.com/lucastercas/arch-install"
  system("arch-chroot /mnt git clone #{install_git} /home/#{username}/workspace/personal/arch-install")
  system("arch-chroot /mnt chown -R #{username}:#{username} /home/#{username}")
end
