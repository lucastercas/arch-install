#!/usr/bin/ruby

require_relative('../lib')

def setup_chroot(config)
  puts("#=== setting up chroot ===#")
  # set_locale()
  # set_mirrors()
  
  packages_file = "configs/packages.yml"
  packages = read_yaml(packages_file)

  install_packages(packages["packages"]["base"].keys)
  # install_packages(packages["packages"]["graphical"].keys)

  system("arch-chroot /mnt mkinitcpio -p linux")

  create_user()
  # To-Do: Update visudo

  puts("#--- root password ---#")
  system("arch-chroot /mnt passwd")

  puts("#--- hostname ---#")
  print("Hostname: ")
  hostname = gets().chomp()
  system("arch-chroot /mnt echo #{hostname} >> /etc/hostname")

  puts("#--- bootloader ---#")
  system("arch-chroot /mnt refind-install")

  enable_services()
end

def set_locale()
  puts("#--- setting locale ---#")
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
  system("arch-chroot /mnt sudo pacman -S --noconfirm #{packages.join(' ')}")
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
