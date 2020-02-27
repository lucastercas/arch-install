def getPackagesFromFile(file)
  packages_file = File.open(file)
  packages = []
  packages_file.each_line do |line|
    if line[0] != '#' then
      packages.append(line.gsub("\n", ''))
    end
  end
  packages = packages.join(' ')
  return packages
end

def installPackages(file)
  packages = getPackagesFromFile("./src/pkgs/#{file}")
  cmd = "arch-chroot /mnt pacman -S --noconfirm #{packages}"
  puts "--> #{cmd}"
  system(cmd)
end

def installPackagesMenu(chrootl)
  puts "\n=== Install Packages Menu ==="
  while true do
    puts "1 - Simple"
    puts "2 - Default"
    puts "0 - Back"
    option = gets.chomp.to_i
    case option
      when 1
        installPackages("simple.txt")
      when 2
        installPackages("default.txt")
      when 0
        break
    end
  end
end
