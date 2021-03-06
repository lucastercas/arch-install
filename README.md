# Arch Installation Script

![logo](./docs/arch-logo.png)
## Before Installation

Connect to network:
```bash
$ iwconfig
$ ip link set <interface> up
$ iwctl
$$ device list # Print Interfaces
$$ station <interface> get-networks # Print Networks
$$ station <interface> connect <ssid>
```

The standard Arch image does not come with Git or Ruby, so you need to install it,
and then clone this repository:
```bash
$ pacman -Sy git ruby
$ git clone https://github.com/lucastercas/arch-install
$ cd arch-install
$ ./main.rb
```

## How to Use
This installation consists of 3 steps:
1. Live: On the ISO
    - Setup, format and partitions
    - pacstrap
    - fstab
2. Chroot: On the chroot environment (`arch-chroot`)
    - locale
    - mirrors
    - packages
    - users
    - bootloader
    - services
3. Personal Files
    - [dotfiles]()

## To-Do
1. GUI of live (?)
2. AUR packages during installation
3. Check if user already existe before creating
4. Add sed of visudo
5. Add dotfiles
    - Configuration Files
    - nvm
    - vim plugins
