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

mount --mkdir $efi_part /mnt/boot
mount $root_part /mnt
swapon $swap_partlslsnan

pacstrap -K /mnt base linux linux-firmware networkmanager grub efibootmgr os-prober sudo nano

genfstab -U /mnt >> /mnt/etc/fstab

nano /mnt/etc/locale.gen
nano /mnt/etc/default/grub

arch-chroot /mnt<<EOF
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc


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
reboot

EOF











