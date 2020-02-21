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
  packages = getPackagesFromFile("pkgs/#{file}")
  cmd = "arch-chroot /mnt pacman -S #{packages}"
  puts "--> #{cmd}"
  system(cmd)
end

def installPackagesMenu()
  while true do
    puts "1 - Base"
    puts "2 - Graphical"
    puts "3 - File Manager"
    puts "4 - Audio"
    puts "5 - Development"
    puts "6 - Fonts"
    puts "7 - Bluetooth"
    puts "8 - Docker"
    puts "9 - Languages"
    puts "0 - Back"
    when 1
      installPackages("base.pkg")
    when 2
      installPackages("graphical.pkg")
    when 3
      installPackages("file-manager.pkg")
    when 4
      installPackages("audio.pkg")
    when 5
      installPackages("development.pkg")
    when 6
      installPackages("fonts.pkg")
    when 7
      installPackages("bluetooth.pkg")
    when 8
      installPackages("docker.pkg")
    when 9
      installPackages("languages.pkg")
    when 0
      break
  end
end
