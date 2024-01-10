#!/bin/bash

ln -sf /usr/share/zoneinfo/xxxx/xxxx /etc/localtime
hwclock --systohc

sed '/en_US.UTF/s/^#//' -i /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'KEYMAP=en_US' > /etc/vconsole.conf

echo 'arch' > /etc/hostname
echo -e "127.0.0.1  localhost\n::1  localhost\n127.0.1.1  arch.localdomain  arch" > /etc/hosts
systemctl enable NetworkManager

# Not necessary as pacstrap already generated an initramfs
#mkinitcpio -P

# Rudimentary way of creating users and giving them default password
echo -e "root\nroot" | passwd
useradd -G wheel,video,audio -m arch
echo -e "root\nroot" | passwd arch

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg

sed '/wheel ALL=(ALL:ALL) ALL/s/^#//' -i /etc/sudoers
