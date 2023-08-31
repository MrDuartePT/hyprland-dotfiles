#!/bin/bash

HDD_DISK_UUID="/dev/disk/by-uuid/9299af67-f63a-4d1c-bd63-082fc90d55a8"
HDD_MOUNT="WD_External"
HDD_MOUNT_DIR="/dev/mapper/$HDD_MOUNT"

i=1

#Force run with root
if [ "$EUID" -ne 0 ]; then
	echo "Note: Please run as root"
	[ "$1" != -h ] && set -- -h
fi
#Verify if disk is connected
test ! -e $HDD_DISK_UUID && echo "Please plug the usb HDD" && exit

mount_disk() {
	#Mount text
	echo "Mounting Disk in:"
	while [[ $i -le 3 ]]; do
		echo ${i}........ && sleep 1
		((++i))
	done

	#Clevis unlock drive
	clevis luks unlock -d $HDD_DISK_UUID -n $HDD_MOUNT
	#Mount root, Games and Onedriver Backup
	mount -o subvol=@ $HDD_MOUNT_DIR /mnt/HDD
	mount -o subvol=@Games_HDD $HDD_MOUNT_DIR /mnt/HDD/Games/
	mount -o subvol=@Onedrive_Backup $HDD_MOUNT_DIR /mnt/HDD/Onedrive/

	echo "Everthing was mount in: /mnt/HDD"
}

umount_disk() {
	#Unmount Text
	echo "Unmounting Disk in:"
	while [[ $i -le 3 ]]; do
		echo ${i}........ && sleep 1
		((++i))
	done

	#Umount BTRFS particions
	umount /mnt/HDD/Onedrive
	umount /mnt/HDD/Games
	umount /mnt/HDD

	#Close LUKS drive
	cryptsetup luksClose $HDD_MOUNT_DIR

	echo "Everthing was unmount you can remove the drive"
}

#Subcomand
case "$1" in
mount | -m)
	test ! -e "$HDD_MOUNT_DIR" && mount_disk || echo "HDD not mounted"
	;;
unmount | -um)
	test -e "$HDD_MOUNT_DIR" && mount_disk || echo "HDD not mounted"
	;;
onedrive_backup | -o_bk)
	test ! -e "$HDD_MOUNT_DIR" && mount_disk
	rsync -auvP Onedrive/ /mnt/HDD/Onedrive/
	echo && echo "Backup Made" && echo && i=1
	umount_disk
	;;
auto)
	echo "Mounting/Unmounting the drive"
	test ! -e "$HDD_MOUNT_DIR" && mount_disk || umount_disk
	;;
-h | --help | *)
	echo && echo "Help menssage:" && echo
	echo "--help or -h -> print this help menssage"
	echo "mount, -m -> Mount the drive"
	echo "umount, -um -> Umount the drive"
	echo "onedrive_backup or -o_bk -> backup Onedrive"
	echo "auto or -a -> mount or umount the drive depending of the status"
	;;
esac
