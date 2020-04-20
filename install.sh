#!/usr/bin/env bash

set -e

# $1 - Number of partition
# $2 - Name of partition
# $3 - Start of partition
# $4 - End of partition
# $5 - Type of partition
# $6 - Disk to create partition
create_partition() {
  cmd="sgdisk -n $1:$3:$4 -c $1:\"$2\" -t $1:$5 $6"
  echo "==> $cmd"; eval $cmd
}

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

# $1 - Partition path
# $2 - Partition type
format_partition() {
  if [ "$2" == "ef00" ]; then
    cmd="mkfs.vfat -F32 $1"
    echo "==> $cmd"; eval "$cmd"
  elif [ "$2" == "8200" ]; then # Swap
    cmd1="mkswap $1"
    echo "==> $cmd1"; eval $cmd1
    cmd2="swapon $1"
    echo "==> $cmd2"; eval $cmd2
  elif [ "$2" == "8300" ] || [ "$2" == "8302" ]; then
    cmd="mkfs.ext4 $1"
    echo "==> $cmd"; eval $cmd
  fi
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

# $1 - Path to disk
# $2 - Path to mount
mount_partition() {
  mkdir -p $2
  mount $1 $2
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

execute_cmd() {
  echo "==> $1"
  eval "arch-chroot /mnt $1"
}

install_packages() {
  packages=""
  while IFS= read -r line; do
    packages="${packages} ${line}"
  done < "$1"
  execute_cmd "pacman -S --noconfirm $packages"
}

echo '    _             _       ___           _        _ _ '
echo '   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |'
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _\` | | |"
echo ' / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |'
echo '/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|'

printf "\n##### DISK #####\n"
lsblk
read -p "Which disk to configure? " disk;
clear_partition="sgdisk -og $disk"
echo "==> $clear_partition"; eval "$clear_partition"
partition_config="./partitions.csv"
start_create_partition $partition_config $disk
start_format_partition $partition_config $disk
start_mount_partition $partition_config $disk

printf "\n##### MIRRORS #####\n"
pacman -S pacman-contrib
curl -s 'https://www.archlinux.org/mirrorlist/?country=BR&protocol=http&protocol=https&ip_version=4&use_mirror_status=on' | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist
pacman-key --init
pacman-key --populate archlinux
pacman -Sy

# Install base system packages
printf "\n##### PACSTRAP #####\n"
cmd="pacstrap -i /mnt base base-devel vim git pacman-contrib curl"
echo "==> $cmd"; eval $cmd

# Create fstab, file that describes how the disk is structured
printf "\n##### FSTAB #####\n"
cmd="genfstab -U /mnt >> /mnt/etc/fstab"
echo "==> $cmd"; eval $cmd

printf "\n##### LOCALE #####\n"
execute_cmd "ln -sf /usr/share/zoneinfo/Brazil/DeNoronha /etc/localtime"
execute_cmd "sed -i s/#pt_BR.UTF-8/pt_BR.UTF-8/ /etc/locale.gen"
execute_cmd "locale-gen"
execute_cmd "hwclock --systohc"
execute_cmd "echo LANG=pt_BR.UTF-8 >> /etc/locale.conf"

printf "\n##### MIRRORS #####\n"
# Update mirrors, so the next package installs are easiers
execute_cmd "curl -s 'https://www.archlinux.org/mirrorlist/?country=BR&protocol=http&protocol=https&ip_version=4&use_mirror_status=on' | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist"
# Update pacman
execute_cmd "pacman-key --init"
execute_cmd "pacman-key --populate archlinux"
execute_cmd "pacman -Sy"

# Install packages
printf "\n##### PACKAGES #####\n"
terminal_pkgs_file="./packages/terminal.txt"
graphical_pkgs_file="./packages/graphical.txt"
install_packages "$terminal_pkgs_file"
install_packages "$graphical_pkgs_file"

printf "\n##### MKINITCPIO #####\n"
execute_cmd "mkinitcpio -p linux"

printf "\n##### USER #####\n"
read -p "Username: " username
read -p "Complete Name: " complete_name
execute_cmd "useradd -m -G wheel,docker  -s /bin/zsh -c \"$complete_name\" $username"
execute_cmd "passwd $username"
execute_cmd "visudo" # Add wheel group permission, for sudo

printf "\n##### ROOT #####\n"
execute_cmd "passwd"

printf "\n##### HOSTNAME #####\n"
read -p "Hostname: " hostname
execute_cmd "echo $hostname >> /etc/hostname"

printf "\n##### GRUB BOOTLOADER #####\n"
# execute_cmd "grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB"
# execute_cmd "grub-install --target=i386-pc $disk"
# execute_cmd "grub-mkconfig -o /boot/grub/grub.cfg"
execute_cmd "refind-install"

# Files
cp -f ./files/70-synaptics.conf /mnt/etc/xorg.conf.d/
cp -f ./files/hosts /mnt/etc/
cp -f ./files/lightdm.conf /mnt/etc/lightdm/

# Enable system services
printf "\n##### SERVICES #####\n"
execute_cmd "systemctl enable NetworkManager.service ntpd.service
ntpdate.service paccache.service lightdm.service docker.service
bluetooth.service"

execute_cmd "runuser -l lucastercas -c 'mkdir -p workspace'"
execute_cmd "runuser -l lucastercas -c 'git clone https://github.com/lucastercas/arch-install workspace/arch-install'"
execute_cmd "runuser -l lucastercas -c './workspace/arch-install/misc.sh'"
