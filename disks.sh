#!/usr/bin/env bash

setup_disks() {
    create
    format
    mount
}

create() {
    sgdisk -n 1:0:+512M 1:"efi" -t 1:ef00 /dev/sdb1
    sgdisk -n 2:0:+15G 2:"root" -t 2:8300 /dev/sdb2
    sgdisk -n 3:0:0 2:"usr" -t 2:8300 /dev/sdb3
    
    sgdisk -n 1:0:+208G 2:"home" -t 1:8302 /dev/sda1
    sgdisk -n 2:0:+207G 2:"var" -t 2:8300 /dev/sda2
    sgdisk -n 3:0:0 3:"tmp" -t 3:8300 /dev/sda3
}

format() {
    mkfs.fat -F32 /dev/sdb1
    mkfs.ext4 /dev/sdb2
    mkfs/ext4 /dev/sdb3
    
    mkfs.ext4 /mnt/sda1
    mkfs.ext4 /mnt/sda2
    mkfs.ext4 /mnt/sda3
}


mount() {
    mkdir -p /mnt/boot /mnt/usr
    mount /dev/sdb2 /mnt
    mount /dev/sdb1 /mnt/boot
    mount /dev/sdb3 /mnt/usr
    
    mkdir -p /mnt/home /mnt/var /mnt/tmp
    mount /dev/sda1 /mnt/home
    mount /dev/sda2 /mnt/var
    mount /dev/sda3 /mnt/tmp
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