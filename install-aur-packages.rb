def getPackagesFromFile(file)
  packages_file = File.open(file)
  packages = []
  packages_file.each_line do |line|
    if line[0] != '#' then
      packages.append(line.gsub("\n", ''))
    end
  end
  packages = packages.join(' ')
end

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
