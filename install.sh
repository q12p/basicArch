#!/bin/bash
set -e

ping -c 1 9.9.9.9 >/dev/null

function insideChroot {
  ln -sf /usr/share/zoneinfo/xxxx/xxxx /etc/localtime
  hwclock --systohc

  sed '/en_US.UTF/s/^#//' -i /etc/locale.gen
  locale-gen
  echo 'LANG=en_US.UTF-8' > /etc/locale.conf
  echo 'KEYMAP=fr_CH' > /etc/vconsole.conf

  echo 'arch' > /etc/hostname
  echo -e "127.0.0.1  localhost\n::1  localhost\n127.0.1.1  arch.localdomain  arch" > /etc/hosts
  systemctl enable NetworkManager

  mkinitcpio -P

  echo -e "root\nroot" | passwd

  grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
  grub-mkconfig -o /boot/grub/grub.cfg

  sed '/wheel ALL=(ALL:ALL) ALL/s/^#//' -i /etc/sudoers
}

if [ $? -eq 0 ];then
  echo -e "Gracefully installing base ArchLinux"

  timedatectl set-timezone xxxx/xxxx
  timedatectl set-ntp true

  sfdisk /dev/vda < uefi.dump

  mkfs.fat -F 32 /dev/vda1
  mkfs.ext4 /dev/vda2

  mount /dev/vda2 /mnt
  mount /dev/vda1 /mnt/boot --mkdir

  pacstrap -K /mnt base linux linux-firmware network-manager sudo grub efibootmgr

  genfstab -U /mnt > /mnt/etc/fstab

  arch-chroot /mnt insideChroot

  poweroff

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


