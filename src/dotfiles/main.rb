#!/usr/bin/ruby

def setup_dotfiles()
  system("clear")
  puts("#=== setting dotfiles ===")
  
  dotfiles_git = "https://github.com/lucastercas/dotfiles"
  system("rm $HOME/.bashrc $HOME/.zshrc")
  system("git clone --base #{dotfiles_git} $HOME/.cfg")
  system("git --git-dir=$HOME/.cfg --work-tree=$HOME checkout")

  install_yay()
  install_aur_pkgs()
end

def install_yay()
  yay_url="https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz"
  system("curl #{yay_url} | tar -xzv; cd yay && makepkg -si")
end

def install_aur_pkgs()
  system("yay -S dropbox")
end