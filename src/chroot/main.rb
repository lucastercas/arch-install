#!/usr/bin/ruby

def set_locale()
  system("#--- setting locale ---#")
  system("arch-chroot /mnt ln -sf /usr/share/zoneinfo/Brazil/DeNoronha /etc/localtime")
  system("arch-chroot /mnt sed -i s/#pt_BR.UTF-8/pt_BR.UTF-8/ /etc/locale.gen")
  system("arch-chroot /mnt locale-gen")
  system("arch-chroot /mnt hwclock --systohc")
  system("arch-chroot /mnt echo LANG=pt_BR.UTF-8 >> /etc/locale.conf")
end

def set_mirrors()
  puts("#--- setting mirrors ---#")
  country='BR'
  url="https://www.archlinux.org/mirrorlist/?country=#{country}&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"
  system("arch-chroot /mnt pacman -S --noconfirm pacman-contrib")
  system("arch-chroot /mnt curl -s #{url} sed -e s/^#Server/Server/ -e /^#/d/ rankmirrors -n 5 - > /etc/pacman.d/mirrorlist")
  system("arch-chroot /mnt pacman-key --init")
  system("arch-chroot /mnt pacman-key --populate archlinux")
  system("arch-chroot /mnt pacman -Sy --noconfirm")
end

def install_packages(packages)
  puts("#--- installing packages")
  packages.each do |package|
    system("arch-chroot /mnt sudo pacman -S --noconfirm #{package}")
  end
end

def create_user()
  puts("#--- creating user ---#")
  print("Username: ")
  username = gets().chomp()
  print("Name: ")
  name = gets().chomp()
  system("arch-chroot /mnt useradd -m -G wheel,docker -s /bin/zsh -c #{name} #{username}")
  system("arch-chroot /mnt passwd #{username}")
end

def enable_services()
  puts("#--- enabling services ---#")
  services = "NetworkManager lightdm ntpd docker bluetooth paccache ntpdate"
  system("arch-chroot /mnt systemctl enable #{services}")
end