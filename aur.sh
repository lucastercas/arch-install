#!/usr/bin/env bash

printf "\n##### YAY #####\n"
curl https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz | tar xzv
(cd yay && makepkg -si)

aur_pkgs_file="./packages/aur.txt"
packages=""
while IFS= read -r line; do
  packages="${packages} ${line}"
done < "$aur_pkgs_file"
cmd="yay -S $packages"
echo "==> $cmd"; eval "$cmd"


# Oh My ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Spaceship Prompt
ZSH_CUSTOM="$HOME/.oh-my-zsh"
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# Node Manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# Dotfiles
rm "$HOME/.zshrc"
rm "$HOME/.bashrc"
git clone --bare https://github.com/lucastercas/dotfiles "$HOME/.cfg"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout
