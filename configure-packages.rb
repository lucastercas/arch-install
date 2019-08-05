# Author: Lucas de Macedo
# Github: lucastercas

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

def installDefaultPackages()
  puts 'Installing Arch Packages'
  default_packages = getPackagesFromFile('default-packages.txt')
  system "sudo pacman -S #{default_packages}"
end

installDefaultPackages()
