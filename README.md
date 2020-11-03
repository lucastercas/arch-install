# Arch Installation Script


## Before Installation

Connect to network:
```bash
$ iwconfig
$ ip link set <interface> up
$ iwctl
$$ device list
$$ station wlan0 get-networks
$$ station wlan0 connect <ssid>
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

## To-Do
1. GUI of live (?)
2. AUR packages during installation
3. Check if user already existe before creating
4. Add sed of visudo
5. Add dotfiles
    - Configuration Files
    - nvm
    - vim plugins
