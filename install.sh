#!/bin/bash
set -e

ping -c 1 9.9.9.9 >/dev/null

if [ $? -eq 0 ];then
  echo -e "Gracefully installing base ArchLinux"

  timedatectl set-timezone xxxx/xxxx
  timedatectl set-ntp true

  # We have to create the partitions before launching the script
  sfdisk /dev/vda < uefi.dump

  mkfs.fat -F 32 /dev/vda1
  mkfs.ext4 /dev/vda2

  mount /dev/vda2 /mnt
  mount /dev/vda1 /mnt/boot --mkdir

  pacstrap -K /mnt base linux linux-firmware networkmanager sudo grub efibootmgr

  genfstab -U /mnt > /mnt/etc/fstab

  cp insideChroot.sh /mnt/
  arch-chroot /mnt ./insideChroot.sh

  reboot

  #checkBootMode

  #updateTime

  #disks

  #mount

  #pacstrap

  #fstab

  #arch-chroot
else
  echo -e "No internet connection found. Internet is on, right?\n\n"
fi


