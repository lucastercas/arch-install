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

def configureLocale(chroot)
  puts "=== Configure Locale ==="
  system "#{chroot} ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime"
  system "#{chroot} sed -i s/#pt_BR.UTF-8/pt_BR.UTF-8/ /etc/locale.gen"
  system "#{chroot} locale-gen"
  system "#{chroot} hwclock --systohc"
  system "#{chroot} echo LANG=pt_BR.UTF-8 >> /etc/locale.conf"
end

def installDefaultPackages(chroot)
  puts "=== Installing Packages ==="
  default_packages= getPackagesFromFile("./default-packages.txt")
  system "#{chroot} pacman --noconfirm -S #{default_packages}"
end

def addUser(chroot)
  puts "=== Add User ==="
  puts "username:"
  username = gets.chomp
  system "#{chroot} useradd -m -G well -s /bin/zsh -c 'Lucas Tercas' #{username}"
  system "#{chroot} passwd #{username}"
end

def configureRoot(chroot)
  puts "=== Configure Root ==="
  system "#{chroot} passwd"
end

def configureHostname(chroot)
  puts "=== Configure Hostname ==="
  puts "hostname:"
  hostname = gets.chomp
  system "#{chroot} echo #{hostname} >> /etc/hostname"
end

def enableServices(chroot)
  puts "=== Enable Services ==="
  system "#{chroot} systemctl enable NetworkManager.service redshift-gtk.service bluetooth.service lightdm.service ntpd.service ntpdate.service paccache.service lightdm.service"
end

def configureBootloader(chroot)
  puts "=== Configure Bootloader ==="
  system "#{chroot} refind-install"
  system "#{chroot} mkinitcpio -p linux"
end

def chrootOptionsMenu()
  chroot = "arch-chroot /mnt"
  while true do
    puts "\n=== Chroot Options Menu ==="
    puts "1 - Configure Locale"
    puts "2 - Install Arch Packages"
    puts "3 - Add User"
    puts "4 - Configure Root"
    puts "5 - Configure Hostname"
    puts "6 - Enable Services"
    puts "7 - Configure Bootloader (rEFInd)"
    puts "8 - Back"
    option = gets.chomp.to_i
    case option
      when 1
        configureLocale(chroot)
      when 2
        installDefaultPackages(chroot)
      when 3
        addUser(chroot)
      when 4
        configureRoot(chroot)
      when 5
        configureHostname(chroot)
      when 6
        enableServices(chroot)
      when 7
        configureBootloader(chroot)
      when 8
        return
    end
  end
end
