
require 'csv'

def printConfiguration(config)
  config.each.with_index do |partition, index|
    if index == 0 then next end
    puts "Name: #{partition[1]}"
    puts "\tNum: #{partition[0]}"
    puts "\tStart: #{partition[2]}"
    puts "\tEnd: #{partition[3]}"
    puts "\tCode: #{partition[4]}"
  end
end

def createPartition(disk, partition)
  puts "--- Creating partition #{partition[0]} - Size: #{partition[2]} - #{partition[3]} ---"
  cmd = "sgdisk -n #{partition[0]}:#{partition[2]}:#{partition[3]} -c #{partition[0]}:\"#{partition[1]}\" -t #{partition[0]}:#{partition[4]} #{disk}"
  puts "-> #{cmd}"
  # system "cmd"
end

def formatPartition(disk, partition)
  volume = "#{disk}#{partition[0]}"
  case partition[4]
  when "ef00"
    puts "-> mkfs.vfat -F32 #{volume}"
    # system "mkfs.vfat -F32 #{volume}"
  when "8200"
    puts "-> mkswap #{volume}"
    # system "mkswap #{volume}"
    puts "-> swapon #{volume}"
    # system "swapon #{volume}"
  when "8300"
    puts "-> mkfs.ext4 #{volume}"
    # system "mkfs.ext4 #{volume}"
  when "8302"
    puts "-> mkfs.ext4 #{volume}"
    # system "mkfs.ext4 #{volume}"
  else
    puts "Code #{partition[4]} not recognized"
  end
end

def mountPartition(disk, partition)
  puts "--- Mounting Partiton #{partition[1]} ---"
  mkdir_cmd = "mkdir -p /mnt#{partition[5]}"
  puts "-> #{mkdir_cmd}"
  system mkdir_cmd
  mount_cmd = "mount #{disk}#{partition[0]} /mnt#{partition[5]}"
  puts "-> #{mount_cmd}"
  system mount_cmd
end

def getConfiguration()
  partitions = CSV.read('partitions.csv')
end

def configureDiskMenu()
  puts "Which disk the configuration refers to?"
  disk = gets.chomp
  while true do
    puts "\n=== Configuring Disks ==="
    config = getConfiguration()
    puts "1 - Print Configuration"
    puts "2 - Create Partitions"
    puts "3 - Format Partitions"
    puts "4 - Mount Partitions"
    puts "5 - Exit"
    option = gets.chomp.to_i
    case option
      when 1
        printConfiguration(config)
      when 2
        config.each.with_index do |partition, index|
          if index == 0 then next end
          createPartition(disk, partition)
        end
      when 3
        config.each.with_index do |partition, index|
          if index == 0 then next end
          formatPartition(disk, partition)
        end
      when 4
        config.each.with_index do |partition, index|
          if index == 0 then next end
          mountPartition(disk, partition)
        end
      when 5
        return
    end
  end
end