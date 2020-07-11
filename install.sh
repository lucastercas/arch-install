#!/bin/bash

set -e -u

source "$(pwd)/src/general.sh"
source "$(pwd)/src/disk.sh"
source "$(pwd)/src/locale.sh"
source "$(pwd)/src/packages.sh"
source "$(pwd)/src/user.sh"

# $1 Path to CSV file
# $2 disk
start_create_partition() {
  i=0
  while IFS=',' read -r f1 f2 f3 f4 f5 f6
  do
    if [ "$i" != 0 ]; then
      printf "\n--- Setting up Partition $f1 ---\n"
      create_partition $f1 $f2 $f3 $f4 $f5 "$disk"
      # echo "$f1 $f2 $f3 $f4 $f5 $f6"
    fi
    let "i+=1"
  done < "$1"
}

# $1 Path to CSV file
# $2 disk
start_format_partition() {
  i=0
  while IFS=',' read -r f1 f2 f3 f4 f5 f6
  do
    if [ "$i" != 0 ]; then
      printf "\n--- Formating Partition $f1 ---\n"
      format_partition "${2}${f1}" "$f5"
    fi
    let "i+=1"
  done < "$1"
}

# $1 Path to CSV file
# $2 disk
start_mount_partition() {
  i=0
  while IFS=',' read -r f1 f2 f3 f4 f5 f6
  do
    if [ "$i" != 0 ]; then
      printf "\n--- Mount Partition $f1 ---\n"
      if [ "$f6" != "" ]; then
        mount_partition "${2}${f1}" "/mnt${f6}"
      fi
    fi
    let "i+=1"
  done < "$1"
}

echo '    _             _       ___           _        _ _ '
echo '   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |'
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _\` | | |"
echo ' / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |'
echo '/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|'

echo "#===== HOST =====#"
echo "#--- Setting disks ---#"
lsblk

echo "#--- Settings Host Mirrors ---#"
set_mirrors execute_cmd

echo "#--- Executing pacstrap ---#"
execute_cmd "pacstrap -i /mnt base base-devel vim git pacman-contrib curl"

echo "#--- Generating fstab ---#"
execute_cmd "genfstab -U /mnt >> /mnt/etc/fstab"

echo "#===== CHROOT =====#"
echo "#--- Setting locale ---#"
set_locale

echo "#--- Setting mirrors ---#"
set_mirros exec_chroot_cmd

echo "#--- Installing packages ---#"
install_packages "./packages/terminal.txt"
install_packages "./packages/graphical.txt"

echo "#--- Generating mkinitcpio ---#"
execute_chroot_cmd "mkinitcpio -p linux"

echo "#--- Setting user ---#"
add_user
# execute_chroot_cmd "visudo" # Add wheel group permission, for sudo
echo 'user ALL=(ALL:ALL) ALL' >> /etc/sudoers

echo "#--- Root password ---#"
execute_cmd "passwd"

echo "#--- Hostname ---#"
read -p "Hostname: " hostname
execute_chroot_cmd "echo $hostname >> /etc/hostname"

echo  "#--- Bootloader ---#"
exectute_chroot_cmd "refind-install"
#execute_chroot_cmd "grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB"
#execute_chroot_cmd "grub-install --target=i386-pc $disk"
#execute_chroot_cmd "grub-mkconfig -o /boot/grub/grub.cfg"

echo "#--- Enable services ---#"
execute_chroot_cmd "systemctl enable NetworkManager ntpd
ntpdate paccache lightdm docker bluetooth"

echo "#--- Misc files ---#"
execute_cmd "cp -f ./files/70-synaptics.conf /mnt/etc/xorg.conf.d/"
execute_cmd "cp -f ./files/hosts /mnt/etc/"
execute_cmd "cp -f ./files/lightdm.conf /mnt/etc/lightdm/"

echo "#--- Config files ---#"
execute_as_user 'mkdir -p workspace'
execute_as_user 'git clone https://github.com/lucastercas/arch-install workspace/arch-install'

echo "#--- Misc programs ---#"
execute_as_user './workspace/arch-install/misc.sh'
