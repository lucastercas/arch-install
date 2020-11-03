#!/usr/bin/ruby

require_relative 'disks'

def setup_disks(disks)
  disks.each do |disk|
    puts("==> Setting up disk #{disk[0]}")
    mount_partitions(disk[0], disk[1])
    format_partitions(disk[0], disk[1])
  end
end
