#!/usr/bin/env bash

set -e

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

# $1 - Partition path
# $2 - Partition type
format_partition() {
  if [ "$2" == "ef00" ]; then
    cmd="mkfs.vfat -F32 $1"
    echo "--> $cmd"
  elif [ "$2" == "8200" ]; then # Swap
    cmd1="mkswap $1"
    cmd2="swapon $1"
    echo "--> $cmd1"
    echo "--> $cmd2"
    eval $cmd1
    eval $cmd2
  elif [ "$2" == "8300" ] || [ "$2" == "8302" ]; then
    cmd="mkfs.ext4 $1"
    echo "==> $cmd"; eval $cmd
  fi
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

# $1 - Path to disk
# $2 - Path to mount
mount_partition() {
  mkdir_cmd="mkdir -p $2"
  echo "==> $mkdir_cmd"; eval "$mkdir_cmd"
  cmd="mount $1 $2"
  echo "==> $cmd"; eval "$cmd"
}

echo '    _             _       ___           _        _ _ '
echo '   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |'
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _\` | | |"
echo ' / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |'
echo '/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|'

printf "\n##### DISK #####\n"

read -p "Which disk to configure?" disk;

clear_partition="sgdisk --clear $disk"
echo "==> $clear_partition"; eval "$clear_partition"

partition_config="./partitions.csv"
start_create_partition $partition_config $disk
start_format_partition $partition_config $disk
start_mount_partition $partition_config $disk

printf "\n##### MIRRORS #####\n"
pacman -S pacman-contrib
cmd="curl -s 'https://www.archlinux.org/mirrorlist/?country=BR&protocol=http&protocol=https&ip_version=4&use_mirror_status=on' | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist"
echo "==> $cmd"; eval $cmd

printf "\n##### PACSTRAP #####\n"
cmd="pacstrap -i /mnt base base-devel vim git pacman-contrib curl"
echo "==> $cmd"; eval $cmd

printf "\n##### FSTAB #####\n"
cmd="genfstab -U /mnt >> /mnt/etc/fstab"
echo "==> $cmd"; eval $cmd

printf "\n##### LOCALE #####\n"
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Brazil/DeNoronha /etc/localtime
arch-chroot /mnt sed -i s/#pt_BR.UTF-8/pt_BR.UTF-8/ /etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt hwclock --systohc
arch-chroot /mnt echo LANG=pt_BR.UTF-8 >> /etc/locale.conf

printf "\n##### MIRRORS #####\n"
arch-chroot /mnt curl -s "https://www.archlinux.org/mirrorlist/?country=BR&protocol=http&protocol=https&ip_version=4&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist

printf "\n##### PACKAGES #####\n"
packages_file="./packages.txt"
packages=""
while IFS= read -r line; do
  packages="${packages} ${line}"
done < "$packages_file"
cmd="arch-chroot /mnt pacman -S --noconfirm $packages"
echo "==> $cmd"; eval "$cmd"

printf "\n##### USER #####\n"
read -p "Username: " username
read -p "Complete Name: " complete_name
arch-chroot /mnt useradd -m -G wheel -s /bin/zsh -c "$complete_name" "$username"
arch-chroot /mnt passwd "$username"

printf "\n##### ROOT #####\n"
arch-chroot /mnt passwd

printf "\n##### HOSTNAME #####\n"
read -p "Hostname: " hostname
cmd="arch-chroot /mnt echo "$hostname" >> /etc/hostname"
echo "==> $cmd"; eval "$cmd"

printf "\n##### GRUB BOOTLOADER #####\n"
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

printf "\n##### SERVICES #####\n"
cmd="arch-chroot /mnt systemctl enable NetworkManager.service ntpd.service ntpdate.service paccache.service"
echo "==> $cmd"; eval "$cmd"
