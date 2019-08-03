#!/usr/bin/env ruby
home = Dir.home()

dotfile_config = "#{home}/git/arch-install/chroot"
home_config = "#{home}/.config"

def mkdir(source)
  system("mkdir -p #{source}")
end
  

def link(source, destination)
  print("Linking #{source} -> #{destination}\n")
  system("ln -sf #{source} #{destination}")
end

Dir.chdir(dotfile_config)

Dir.children(".").each do |main_config_dir|
  if main_config_dir == 'install.rb' then
    next
  end
  Dir.chdir("#{dotfile_config}/#{main_config_dir}")
  Dir.children(".").each do |home_dir_config|
    if File.file?(home_dir_config) then
      link("#{Dir.pwd}/#{home_dir_config}", "#{home}/.#{home_dir_config}")
    else
      Dir.chdir("#{dotfile_config}/#{main_config_dir}/#{home_dir_config}")
      Dir.children(".").each do |config_file|
        mkdir("#{home_config}/#{home_dir_config}")
        link("#{Dir.pwd}/#{config_file}", "#{home_config}/#{home_dir_config}/#{config_file}")
      end
    end
  end
end
