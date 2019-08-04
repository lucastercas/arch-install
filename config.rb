#!/usr/bin/env ruby

if ARGV.include?('files') then
  puts "\n====== Copying Config Files ======"
  load "./config/install.rb"
end

if ARGV.include?('programs') then
  puts("\n====== Installing Misc Programs ======")
  puts("\n=== Installing FZF ===")
  system("git clone b-depth 1 https://github.com/junegunn/fzf.git ~/.fzf")
  system("~/.fzf/install")

  puts("\n=== Installing Plug ===")
  #system("curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
  `curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

  puts "\n=== Installing Oh My ZSH ==="
  `curl -o- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash`

  puts "\n=== Installing NVM ==="
  `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash`

  puts "\n=== Installing Trizen ==="
  `git clone https://aur.archlinux.org/trizen.git ~/Downloads/trizen`
  `cd ~/Downloads/yay`
  `makepkg -si`

  puts "\n=== Setting Spotify Cache Size"
  `echo "storage.size=3072" >> ~/.config/spotify/prefs`
end

if ARGV.include?('services') then
  load "./services.rb"
end
