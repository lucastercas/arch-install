#!/bin/bash

dotfiles="$HOME/git/dotfiles"

#===== Trizen =====#
echo '===== Trizen ======'
read -r -p 'Install Trizen? [yes/no]' trizen
if [ "$trizen" = "yes" ]; then
  mkdir -p "$HOME/Downloads"
  git clone https://aur.archlinux.org/trizen.git "$HOME/Downloads"
  cd "$HOME/Downloads/trizen" || exit
  makepkg -si
  cd || exit
fi

#===== Arch =====
echo "===== Arch ====="
read -r -p 'Sort Pacman Mirrors? [yes/no] ' pac_mirrors
if [ "$pac_mirrors" = "yes" ]; then
  sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
  awk '/^## Brazil$/{f=1}f==0{next}/^$/{exit}{print substr($0, 2)}' /etc/pacman.d/mirrorlist.backup
  sudo sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
  sudo rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
fi

read -r -p 'Install Arch default packages? [yes/no] ' default_packages
if [ "$default_packages" = "yes" ]; then
  sudo pacman -S --needed - < "$dotfiles/arch/default-packages.txt"
else
  echo 'Skipping installation of default packages'
fi

read -r -p 'Install AUR packages? [yes/no] ' aur_packages
if [ "$aur_packages" = "yes" ]; then
  trizen -S --needed - < "$dotfiles/arch/aur-packages.txt"
else
  echo 'Skipping installation of AUR packages'
fi
