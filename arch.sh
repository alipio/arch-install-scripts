#!/bin/bash

pacman --noconfirm --needed -Sy libnewt || { echo "Error at script start: Are you sure you're running this as the root user? Are you sure you have an internet connection?"; exit; }

whiptail --title "DON'T BE A BRAINLET!" --yesno "This is an Arch install script that is very rough around the edges.\n\nOnly run this script if you're a big-brane who doesn't mind deleting your entire /dev/sda drive."  12 60 || exit

whiptail --nocancel --inputbox "Enter a name for your computer." 10 60 2>comp

whiptail --title "Time Zone select" --yesno "Do you want use the default time zone(America/Sao_Paulo)?.\n\nPress no for select your own time zone"  10 60 && echo "America/Sao_Paulo" > tz.tmp || tzselect > tz.tmp

whiptail --nocancel --inputbox "Enter partitionsize in gb, separated by space (root & swap)." 10 60 2>psize

IFS=' ' read -ra SIZE <<< $(cat psize)

re='^[0-9]+$'
if ! [ ${#SIZE[@]} -eq 2 ] || ! [[ ${SIZE[0]} =~ $re ]] || ! [[ ${SIZE[1]} =~ $re ]] ; then
    SIZE=(25 4);
fi

timedatectl set-ntp true

cat <<EOF | fdisk /dev/sda
o
n
p


+200M
n
p


+${SIZE[0]}G
n
p


+${SIZE[1]}G
n
p


w
EOF
partprobe

yes | mkfs.ext4 /dev/sda4
yes | mkfs.ext4 /dev/sda2
yes | mkfs.ext4 /dev/sda1
mkswap /dev/sda3
swapon /dev/sda3
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir -p /mnt/home
mount /dev/sda4 /mnt/home

pacman -Sy --noconfirm archlinux-keyring

pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab
cat tz.tmp > /mnt/tzfinal.tmp
rm tz.tmp
mv comp /mnt/etc/hostname
curl https://raw.githubusercontent.com/alipio/arch-install-scripts/master/chroot.sh > /mnt/chroot.sh && arch-chroot /mnt bash chroot.sh && rm /mnt/chroot.sh

whiptail --title "Final Qs" --yesno "Reboot computer?" 7 30 && reboot
whiptail --title "Final Qs" --yesno "Return to chroot environment?" 7 30 && arch-chroot /mnt
clear
