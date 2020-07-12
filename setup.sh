#!/bin/bash

set -eux

read -p "Username: " username

chroot_cmd="arch-chroot /mnt"
cmd_as_user="${chroot_cmd} runuser -l ${username}"

echo "#--- Install YAY ---#"
yay_url="https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz"
${cmd_as_user} -c "curl ${yay_url} | tar -xzv; cd yay && makepkg -si"

echo "#--- Install AUR Packages ---"
aur_pkgs_file="./aur.txt"
aur_packages=""
while IFS= read -r line; do
  aur_packages="${packages} ${line}"
done < "${aur_pkgs_file}"
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