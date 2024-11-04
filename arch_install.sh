setfont -d
timedatectl

echo "Enter a efi partition:"
read efi_part
echo "Enter a root partition:"
read root_part
echo "Enter a swap partiton:"
read swap_part

mkfs.fat -F 32 $efi_part
mkfs.ext4 $root_part
mkswap $swap_part

mount --mkdir $efi_part /mnt/efi
mount $root_part /mnt
swapon $swap_part

pacstrap -K /mnt base linux linux-firmware networkmanager grub efibootmgr os-prober sudo nano

genfstab -U /mnt >> /mnt/etc/fstab


echo "ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

nano /etc/locale.gen
nano /etc/default/grub


locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "arch" > /etc/hostname

mkinitcpio -P

passwd

systemctl enable NetworkManager

useradd -m arch
passwd arch
EDITOR=nano visudo


grub-install --efi-directory=/efi
grub-mkconfig -o /boot/grub/grub.cfg

exit
umount -a
reboot" > /mnt/chroot_script.sh

chmod +x chroot_script.sh



arch-chroot /mnt ./chroot_script.sh











