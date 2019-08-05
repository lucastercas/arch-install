def installYay()
  puts "Installing Yay"
  system "git clone https://aur.archlinux.org/yay.git ~/Downloads/yay"
  system "cd ~/Downloads/yay"
  system "makepkg -si"
end

def installAurPackages()
  puts "Installing AUR Packages"
  aur_packages = getPackagesFromFile("aur-packages.txt")
  system "yay -S #{aur_packages}"
end

installYay()
installAurPackages()
