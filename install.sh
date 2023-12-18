#!/bin/bash

if [ ping -c 1 9.9.9.9 >&/dev/null ];then
  echo -e "Gracefully installing base ArchLinux"
  checkBootMode

  updateTime

  disks

  mount

  pacstrap

  fstab

  arch-chroot
else
  echo -e "No internet connection found. Internet is on, right?\n\n"
fi


