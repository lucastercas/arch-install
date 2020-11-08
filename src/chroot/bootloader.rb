#!/usr/bin/ruby

def bootloader(config)
  puts("#--- bootloader ---#")
  system("arch-chroot /mnt mkdir -p /boot/grub")
  system("arch-chroot /mnt /bin/bash <<END 
  grub-mkconfig -o /boot/grub/grub.cfg
  END")
  system("arch-chroot /mnt grub-install /dev/#{config['disks'][0]['name']}")
  # system("arch-chroot /mnt refind-install")
end