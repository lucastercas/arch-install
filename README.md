# Arch Install

## iso

### Set keyboard layout:
```
ls /usr/share/kdb/keymaps/**/*.map.gz
./configure-keyboard.rb <layout>
```

### Set network:
```
wifi-menu
ping -c 3 google.com
ip addr show
systemctl stop dhcpdc@<interface>
```

### Set Date and Time:
```
./configure-timedate.rb
```

### Set disk:
```
fdisk -l
./configure-disk <disk>
```

### Encrypt:

### Package Installation:
```
./configure-packages.rb
```

## chroot

### Set password:
```
passwd
```

### Install Packages:
```
./configure-packages.rb
```

### Timezone:
```
./configure-location.rb <location>
```

### Hostname:
```
./configure-hostname.rb <hostname>
```

Add the following to */etc/hosts*:
```
127.0.0.1 localhost
::1 localhost
127.0.1.1 <hostname>.localdomain <hostname>
```

### Grub:
```
./configure-grub.rb
```

### Exit:
```
exit
umount -a
reboot
```




