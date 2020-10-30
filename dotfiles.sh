#!/bin/bash

echo "#--- Dotfiles ---#"

rm /mnt/home/${USERNAME}/.bashrc /mnt/home/${USERNAME}/.zshrc
dotfiles_url="https://github.com/lucastercas/dotfiles"
${cmd_as_user} -c "git clone --bare ${dotfiles_url} /home/${USERNAME}/.cfg"
${cmd_as_user} -c "git --git-dir=/home/${USERNAME}/.cfg/ --work-tree=/home/${USERNAME} checkout"
