#!/usr/bin/env bash

# $1 -> Number
# $2 -> Name 
# $3 -> Start
# $4 -> End
# $5 -> Type
# $6 -> Disk
createPartition(){ 
  execCmd "sgdisk -n $1:$3:$4 -c $1:\"$2\" -t $1:$5 $6"
}

# $1 - Partition path
# $2 - Partition type
formatPartition() {
  if [ "$2" == "ef00" ]; then
    execCmd "mkfs.vfat -F32 $1"
  elif [ "$2" == "8200" ]; then # Swap
    execCmd "mkswap $1"
    execCmd "swapon $1"
  elif [ "$2" == "8300" ] || [ "$2" == "8302" ]; then
    execCmd "mkfs.ext4 $1"
  fi
}

# $1 - Path to disk
# $2 - Path to mount
mountPartition() {
  execCmd "mkdir -p $2"
  execCmd "mount $1 $2"
}
