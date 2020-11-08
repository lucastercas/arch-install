#!/usr/bin/ruby

def setup_dotfiles(config)
  install_aur_pkgs()
end

def install_yay()
  puts("#--- installing yay ---#")
  yay_url="https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz"
  system("curl #{yay_url} | tar -xzv; cd yay && makepkg -si")
end

def install_aur_pkgs()
  puts("#--- installing aur packages ---#")

  puts("#--- refreshing pacman keys ---#")
  keyserver = "hkp://keys.gnupg.net:80"
  #system("echo 'keyserver #{keyserver}' > ~/.gnupg/gpg.conf")
  system("sudo pacman-key --keyserver #{keyserver} --refresh-keys") # Refresh GPG keys

  packages_file = "configs/packages.yml"
  packages = read_yaml(packages_file)
  packages = packages['packages']['aur']
  packages.each do |pkg|
    puts("#--- installing #{pkg} ---#")
    system("yay --noconfirm -S #{pkg}")
  end
end

def nvm()
  puts("#--- installing nvm ---#")
  system("yay --noconfirm -S nvm")
  system("bash -c 'export NVM_DIR=$HOME/.nvm && source /usr/share/nvm/nvm.sh && nvm install --lts'")
  # version = "v0.36.0"
  # script_url = "https://raw.githubusercontent.com/nvm-sh/nvm/#{version}/install.sh"
  # system("curl -fsSL #{script_url} | bash")
  # system("nvm install --lts")
end

def oh_my_zsh()
  puts("#--- installing oh my zsh ---#")
  system("rm -rf ${HOME}/.oh-my-zsh")
  script_url = "https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
  system("curl -fsSL #{script_url} | bash")

  puts("#--- installing spaceship ---#")
  spaceship_git = "https://github.com/denysdovhan/spaceship-prompt.git"
  zsh_path="${HOME}/.oh-my-zsh/custom"
  system("git clone #{spaceship_git} #{zsh_path}/themes/spaceship-prompt --depth=1")
  system("ln -s #{zsh_path}/themes/spaceship-prompt/spaceship.zsh-theme #{zsh_path}/themes/spaceship.zsh-theme")
end

def greeter()
  puts("#--- setting greeter to lightdm-webkit2-greeter")
  default = "#greeter-session=example-gtk-gnome"
  replace = "greeter-session=lightdm-webkit2-greeter"
  file = "/etc/lightdm/lightdm.conf"
  system("sudo sed -i s/#{default}/#{replace}/ #{file}")
end

def vim_plug()
  puts("#--- installing vim plug---#")
  script_url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  system("curl -fLo ~/.vim/autoload/plug.vim --create-dirs #{script_url}")
  system("vim -c PlugInstall")
  system("chdir ~/.config/coc/extensions && npm i")
end

def refind()
  puts("#--- setting bootloader as refind ---#")
  system("refind-install")
end
