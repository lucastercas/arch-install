#!/usr/bin/ruby

def setup_dotfiles(config)
  system("clear")
  puts("#=== setting dotfiles ===")
  
  oh_my_zsh()
  
  dotfiles_git = "https://github.com/lucastercas/dotfiles"
  system("rm -rf ${HOME}/.cfg")
  system("git clone --bare #{dotfiles_git} ${HOME}/.cfg")
  system("git --git-dir=${HOME}/.cfg --work-tree=${HOME} checkout --force")

  nvm()
  puts("#--- install node lts ---#")
  system("nvm install --lts")
  vim_plug()
  themes()
  install_yay()
  install_aur_pkgs()
end

def install_yay()
  puts("#--- installing yay ---#")
  yay_url="https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz"
  system("curl #{yay_url} | tar -xzv; cd yay && makepkg -si")
end

def install_aur_pkgs()
  puts("#--- installing aur packages ---#")
  system("sudo pacman-key --keyserver pool.sks-keyserver.net --refresh-keys")
  packages_file = "configs/packages.yml"
  packages = read_yaml(packages_file)
  packages = packages['packages']['aur']
  packages.each do |pkg|
    system("yay -S pkg")
  end
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
  zsh_path="${HOME}/.oh-my-zsh/custom"
  system("git clone #{spaceship_git} #{zsh_path}/themes/spaceship-prompt --depth=1")
  system("ln -s #{zsh_path}/themes/spaceship-prompt/spaceship.zsh-theme #{zsh_path}/themes/spaceship.zsh-theme")
end

def vim_plug()
  puts("#--- installing vim plug---#")
  script_url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  system("curl -fLo ~/.vim/autoload/plug.vim --create-dirs #{script_url}")
end
