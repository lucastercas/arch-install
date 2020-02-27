def genfstab()
  puts "\n=== Generating fstab File ==="
  cmd = "genfstab -U -p /mnt >> /mnt/etc/fstab"
  puts "--> #{cmd}"
  system cmd
end
