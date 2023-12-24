#!/bin/bash

echo "Enter the device to mount (e.g., /dev/mmcblk0p2):"
read device

sudo mount $device /mnt

sudo rsync -av --exclude='/home/pi/NAS' --exclude='/mnt' --exclude='/proc/*' --exclude='/sys/*' --exclude='/dev/*' --exclude='/run/*' --delete / /mnt
sudo umount /mnt
echo "Backup is finished"
