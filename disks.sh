#!/usr/bin/env bash

setup_disks() {
  echo "oi"
}

# $1 - Number of partition
# $2 - Name of partition
# $3 - Start of partition
# $4 - End of partition
# $5 - Type of partition
# $6 - Disk to create partition
create_partition() {
  cmd="sgdisk -n $1:$3:$4 -c $1:\"$2\" -t $1:$5 $6"
  echo "==> $cmd"; eval $cmd
}

# $1 Path to CSV file
# $2 disk
start_create_partition() {
  i=0
  while IFS=',' read -r f1 f2 f3 f4 f5 f6
  do
    if [ "$i" != 0 ]; then
      printf "\n--- Setting up Partition $f1 ---\n"
      create_partition $f1 $f2 $f3 $f4 $f5 "$disk"
      # echo "$f1 $f2 $f3 $f4 $f5 $f6"
    fi
    let "i+=1"
  done < "$1"
}

# $1 - Partition path
# $2 - Partition type
format_partition() {
  if [ "$2" == "ef00" ]; then
    cmd="mkfs.vfat -F32 $1"
    echo "==> $cmd"; eval "$cmd"
  elif [ "$2" == "8200" ]; then # Swap
    cmd1="mkswap $1"
    echo "==> $cmd1"; eval $cmd1
    cmd2="swapon $1"
    echo "==> $cmd2"; eval $cmd2
  elif [ "$2" == "8300" ] || [ "$2" == "8302" ]; then
    cmd="mkfs.ext4 $1"
    echo "==> $cmd"; eval $cmd
  fi
}

# $1 Path to CSV file
# $2 disk
start_format_partition() {
  i=0
  while IFS=',' read -r f1 f2 f3 f4 f5 f6
  do
    if [ "$i" != 0 ]; then
      printf "\n--- Formating Partition $f1 ---\n"
      format_partition "${2}${f1}" "$f5"
    fi
    let "i+=1"
  done < "$1"
}

# $1 - Path to disk
# $2 - Path to mount
mount_partition() {
  mkdir -p $2
  mount $1 $2
}

# $1 Path to CSV file
# $2 disk
start_mount_partition() {
  i=0
  while IFS=',' read -r f1 f2 f3 f4 f5 f6
  do
    if [ "$i" != 0 ]; then
      printf "\n--- Mount Partition $f1 ---\n"
      if [ "$f6" != "" ]; then
        mount_partition "${2}${f1}" "/mnt${f6}"
      fi
    fi
    let "i+=1"
  done < "$1"
}