#!/usr/bin/env ruby
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
  return packages
end

puts "\n### chroot ###"

puts "=== Configuring Locale ==="
system "ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
system "sed -i s/#pt_BR.UTF-8/pt_BR.UTF-8/ /etc/locale.gen"
system "locale-gen"
system "hwclock --systohc"
system "echo LANG=pt_BR.UTF-8 >> /etc/locale.conf"

puts "=== Installing Additional Packages ==="
#default_packages = getPackagesFromFile('/opt/default-packages.txt')
#system "pacman -S #{default_packages}"

puts "=== Configuring Hostname ==="
#puts "Hostname: "
#hostname = gets.chomp
#system "echo #{hostname} >> /etc/hostname"

#system "mkinitcpio -p linux"

#system "passwd"

puts "=== Configuring BootLoader (rEFInd) ==="
#system "refind-install"

puts "=== Configuring User ==="
#puts "User: "
#username = gets.chomp
#system "useradd -m -G wheel -s /bin/zsh -c 'Lucas Tercas' #{username}"
#system "passwd #{username}"

puts "=== Enabling Services ==="
#system "systemctl enable NetworkManager.service"
#system "systemctl enable redshift-gtk.service"
#system "systemctl enable bluetooth.service"
#system "systemctl enable lightdm.service"
#system "systemctl enable ntpd.service"
#system "systemctl enable nptdate.service"
#system "systemctl enable paccache.timer"
#system "systemctl enable lightdm.service"
