def setupPacstrap()
  puts  "\n=== Configuring Pacstrap =="
  cmd = "pacstrap -i /mnt base base-devel ruby"
  puts "-> #{cmd}"
  system cmd
end