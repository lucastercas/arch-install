#!/usr/bin/env bash

printf "\n##### YAY #####\n"
curl https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz | tar xzv
(cd yay && makepkg -si)

printf "\n##### Aur Packaged #####"
aur_pkgs_file="$HOME/workspace/arch-install/packages/aur.txt"
packages=""
while IFS= read -r line; do
  packages="${packages} ${line}"
done < "$aur_pkgs_file"
cmd="yay -S $packages"
echo "==> $cmd"; eval "$cmd"

printf "\n##### Oh My ZSH #####"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

printf "\m##### Vundle####"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

printf "\m##### Spaceship Prompt ####"
ZSH_CUSTOM="$HOME/.oh-my-zsh"
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

printf "\n##### NVM #####"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

printf "\n##### Dotfiles #####"
rm "$HOME/.zshrc"
rm "$HOME/.bashrc"
git clone --bare https://github.com/lucastercas/dotfiles "$HOME/.cfg"
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
