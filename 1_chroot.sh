#!/usr/bin/env bash

# Activar SSHD y habilitar el usuario root
echo -e "\nSSHD.\n"
systemctl enable sshd
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' "/etc/ssh/sshd_config"

# Zona horaria
echo -e "\nZona.\n"
ln -sf /usr/share/zoneinfo/America/Buenos_Aires /etc/localtime
hwclock --systohc

# Idioma
echo -e "\nIdioma.\n"
sed -i 's/#es_AR.UTF-8 UTF-8/es_AR.UTF-8 UTF-8/g' "/etc/locale.gen"
sed -i 's/#es_AR ISO-8859-1/es_AR ISO-8859-1/g' "/etc/locale.gen"
locale-gen
echo -e "LANG=es_AR.UTF-8" > /etc/locale.conf
echo -e "KEYMAP=es" > /etc/vconsole.conf

# Nombre Equipo
echo -e "\nNombreEquipo.\n"
read -rp "Ingrese el nombre del equipo: " EQUIPO
read -rp "Ingrese el nombre del dominio: " DOMINIO

echo -e "${EQUIPO}" > /etc/hostname
{
    echo -e "127.0.0.1\tlocalhost"
    echo -e "::1\t\tlocalhost"
    echo -e "127.0.1.1\t${EQUIPO}.${DOMINIO}\t${EQUIPO}"
} >> /etc/hosts

# Network Manager
echo -e "\nNetwork Manager.\n"
pacman -S networkmanager --noconfirm
pacman -S network-manager-applet --noconfirm
systemctl enable NetworkManager

# Grub
echo -e "\nGrub.\n"
pacman -S grub --noconfirm
pacman -S efibootmgr --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Password Root
echo -e "\nPassword Root.\n"
passwd

# Salida
echo -e "\nSalida.\n"
exit