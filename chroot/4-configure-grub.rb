# Author: Lucas de Macedo
# Github: lucastercas

# Usage: ./configure-grub.rb
# Ex: ./configure-grub.rb

puts "=== Configuring Grub ==="

system("grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=grub_uefi --recheck")
#"cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo"
system("grub-mkconfig -o /boot/grub/grub.cfg")
© 2019 GitHub, Inc.
