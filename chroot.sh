# Potential variables: timezone, lang and local

passwd

TZuser=$(cat tzfinal.tmp)

ln -sf /usr/share/zoneinfo/$TZuser /etc/localtime

hwclock --systohc

echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen

pacman --noconfirm --needed -S networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager

pacman --noconfirm --needed -S grub && grub-install --target=i386-pc /dev/sda && grub-mkconfig -o /boot/grub/grub.cfg

pacman --noconfirm --needed -S libnewt
arisa() { curl -O https://raw.githubusercontent.com/alipio/ARISA/master/arisa.sh && bash arisa.sh ;}
whiptail --title "Install Alipio's Rice" --yesno "This install script will easily let you access Alipio's Ricing Script for Arch Linux (ARISA) which automatically install a full Arch Linux dwm desktop environment.\n\nIf you'd like to install this, select yes, otherwise select no."  12 60 && arisa
