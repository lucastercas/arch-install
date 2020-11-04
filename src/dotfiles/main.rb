#!/usr/bin/ruby

def setup_dotfiles(config)
  system("clear")
  puts("#=== setting dotfiles ===")
  
  oh_my_zsh()
  
  dotfiles_git = "https://github.com/lucastercas/dotfiles"
  system("rm $HOME/.bashrc $HOME/.zshrc")
  system("git clone --bare #{dotfiles_git} ${HOME}/.cfg")
  system("git --git-dir=${HOME}/.cfg --work-tree=${HOME} checkout")

  install_yay()
  install_aur_pkgs()
  nvm()
  themes()
end

def install_yay()
  puts("#--- installing yay ---#")
  yay_url="https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz"
  system("curl #{yay_url} | tar -xzv; cd yay && makepkg -si")
end

def install_aur_pkgs()
  puts("#--- installing aur packages ---#")
  packages_file = "configs/packages.yml"
  packages = read_yaml(packages_file)
  system("sudo pacman-key --refresh-keys")
  system("yay -S #{packages['packages']['aur'].keys.join(' ')}")
end

def nvm()
  puts("#--- installing nvm ---#")
  version = "v0.36.0"
  script_url = "https://raw.githubusercontent.com/nvm-sh/nvm/#{version}/install.sh"
  system("curl -fsSL #{script_url} | bash")
end

def oh_my_zsh()
  puts("#--- installing oh my zsh ---#")
  script_url = "https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
  system("curl -fsSL #{script_url} | bash")
end

def themes()
  puts("#--- installing spaceship ---#")
  spaceship_git = "https://github.com/denysdovhan/spaceship-prompt.git"
  system("git clone #{spaceship_git} \"${ZSH_CUSTOM}/themes/spaceship-prompt\" --depth=1")
  system("ln -s \"${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme\" \"${ZSH_CUSTOM}/themes/spaceship.zsh-theme\" 
  ")
end