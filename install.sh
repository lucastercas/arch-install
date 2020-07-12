#!/bin/bash

# read_package_list() {
#   packages=""
#   while IFS= read -r line; do
#       packages="${packages} ${line}"
#   done < "$1"
#   return $packages
# }

set -eux

# source "$(pwd)/src/general.sh"
# source "$(pwd)/src/disk.sh"
# source "$(pwd)/src/locale.sh"
# source "$(pwd)/src/packages.sh"
# source "$(pwd)/src/user.sh"

chroot_cmd="arch-chroot /mnt"

# echo '    _             _       ___           _        _ _ '
# echo '   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |'
# echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _\` | | |"
# echo ' / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |'
# echo '/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|'

# echo "#===== Live Medium =====#"
# echo "#--- Setting disks ---#"
# lsblk

# read -p "Disk: " disk

# echo "#--- Execute pacstrap ---#"
# pacstrap -i /mnt base base-devel

# echo "#--- Generate fstab ---#"
# genfstab -U /mnt >> /mnt/etc/fstab

# echo "#===== CHROOT =====#"
# echo "#--- Setting locale ---#"
# ${chroot_cmd} ln -sf /usr/share/zoneinfo/Brazil/DeNoronha /etc/localtime
# ${chroot_cmd} sed -i s/#pt_BR.UTF-8/pt_BR.UTF-8/ /etc/locale.gen
# ${chroot_cmd} locale-gen
# ${chroot_cmd} hwclock --systohc
# ${chroot_cmd} echo LANG=pt_BR.UTF-8 >> /etc/locale.conf

# echo "#--- Setting mirrors ---#"
# mirrors_url='https://www.archlinux.org/mirrorlist/?country=BR&protocol=http&protocol=https&ip_version=4&use_mirror_status=on'
# ${chroot_cmd} pacman -S --noconfirm pacman-contrib
# ${chroot_cmd} curl -s "$mirrors_url" \
# | sed -e 's/^#Server/Server/' -e '/^#/d' \
# | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist
# ${chroot_cmd} pacman-key --init
# ${chroot_cmd} pacman-key --populate archlinux
# ${chroot_cmd} pacman -Sy --noconfirm

# echo "#--- Installing packages ---#"
# terminal_packages=""
# while IFS= read -r line; do
#     terminal_packages="${terminal_packages} ${line}"
# done < "./packages/terminal.txt"
# ${chroot_cmd} pacman -S --noconfirm ${terminal_packages}

# graphical_packages=""
# while IFS= read -r line; do
#     graphical_packages="${graphical_packages} ${line}"
# done < "./packages/graphical.txt"
# ${chroot_cmd} pacman -S --noconfirm ${graphical_packages}

# echo "#--- Generating mkinitcpio ---#"
# ${chroot_cmd} mkinitcpio -p linux

# echo "#--- Setting user ---#"
# username=""
read -p "Username: " username
# complete_name=""
# read -p "Complete Name: " complete_name
# ${chroot_cmd} useradd -m -G wheel,docker -s /bin/zsh -c "${complete_name}" "${username}"
# ${chroot_cmd} passwd "${username}"
# # execute_chroot_cmd "visudo" # Add wheel group permission, for sudo
# ${chroot_cmd} echo 'user ALL=(ALL:ALL) ALL' >> /etc/sudoers

# echo "#--- Root password ---#"
# ${chroot_cmd} passwd

# echo "#--- Hostname ---#"
# read -p "Hostname: " hostname
# ${chroot_cmd} echo "$hostname" >> /etc/hostname

# echo  "#--- Bootloader ---#"
# ${chroot_cmd} refind-install
# #execute_chroot_cmd "grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB"
# #execute_chroot_cmd "grub-install --target=i386-pc $disk"
# #execute_chroot_cmd "grub-mkconfig -o /boot/grub/grub.cfg"

# echo "#--- Enable services ---#"
# ${chroot_cmd} systemctl enable \
# NetworkManager \
# lightdm \
# ntpd \
# docker \
# bluetooth \
# paccache \
# ntpdate

echo "#--- Misc files ---#"
cp -f ./files/70-synaptics.conf /mnt/etc/X11/xorg.conf.d/
cp -f ./files/hosts /mnt/etc/
cp -f ./files/lightdm.conf /mnt/etc/lightdm/

cmd_as_user="${chroot_cmd} runuser -l ${username}"

echo "#--- Install YAY ---#"
yay_url="https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz"
${cmd_as_user} -c "curl ${yay_url} | tar xzv; cd yay && makepkg -si"

echo "#--- Install AUR Packages ---"
aur_pkgs_file="./packages/aur.txt"
aur_packages=""
while IFS= read -r line; do
  aur_packages="${packages} ${line}"
done < "$aur_pkgs_file"
${cmd_as_user} -c "yay --noconfirm -S ${aur_packages}"

echo "#--- Install NVM ---#"
nvm_url="https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh"
${cmd_as_user} -c "curl -o- ${nvm_url} | bash"

echo "#--- Oh My ZSH ---#"
omz_url="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
${cmd_as_user} -c "sh -c $(curl -fsSL ${omz_url})"

echo "#--- SpaceShip Prompt ---#"
spaceship_url="https://github.com/denysdovhan/spaceship-prompt.git"
zsh_dir="/home/$username/.oh-my-zsh"
${cmd_as_user} -c "git clone ${spaceship_url} ${zsh_dir}/themes/spaceship-prompt"
${cmd_as_user} -c "ln -s ${zsh_dir}/spaceship-prompt/spaceship.zsh-theme ${zsh_dir}/themes/spaceship.zsh-theme"

echo "#--- Dotfiles ---#"
dotfiles_url="https://github.com/lucastercas/dotfiles"
${cmd_as_user} git clone --base "${dotfiles_url}" "/home/${username}/.cfg"
${cmd_as_user} git --git-dir="/home/${username}/.cfg/" --work-tree="/home/${username}" checkout

# echo "#--- Config files ---#"
# ${chroot_cmd} runuser -l "$username" mkdir -p workspace
# ${chroot_cmd} runuser -l "$username" git clone https://github.com/lucastercas/arch-install workspace/arch-install

# echo "#--- Misc programs ---#"
# ${chroot_cmd} runuser -l "$username" "$HOME/workspace/arch-install/misc.sh"
