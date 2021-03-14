#!/usr/bin/env bash

# Teclado
loadkeys es

# NTP
timedatectl set-ntp true
sleep 1

# Particionado de disco
echo -e "\nListado de discos locales.\n"
lsblk

while :
do
    read -rp "Seleccione el disco de instalacion (Ej.:/dev/sda) o 0 para cancelar: " DISCO
    if [ -b "$DISCO" ];
    then
        break
    elif [ "$DISCO" -eq 0 ] 2>/dev/null;
    then
        poweroff
    else
        echo -e "\nDebe indicar un dispositivo válido.\n"
    fi
done

# Preparado del disco
echo -e "\nEl instalador borrara todas las particiones del disco indicado.\n"
read -rp "Desea proceder? (S/N): " BD
if [ "$BD" == "S" ];
then
    sgdisk -Z "$DISCO"
    sgdisk -a 2048 -o "$DISCO"
else
    poweroff
fi

# Crear particiones
while :
do
    read -rp "Indique el tamaño de la particion EFI (Ej.: 600M): " EFI
    if [ "${EFI: -1}" != "M" ];
    then
        echo "La unidad de medida debe ser en MiB indicandolo con una 'M' al final del valor."
        continue
    fi
    if [ "${EFI::-1}" -ge 550 ] && [ "${EFI::-1}" -le 650 ];
    then
        break
    else
        echo "El tamaño de la particion EFI debe ser entre 550MiB y 650MiB."
        continue
    fi
done
sgdisk -n 1:0:+"$EFI" "$DISCO"

while :
do
    read -rp "Indique el tamaño de la particion ROOT (Ej.: 28G): " RT
    if [ "${RT: -1}" != "G" ]; 
    then
        echo "La unidad de medida debe ser en GiB indicandolo con una 'G' al final del valor."
        continue
    fi
    if [ "${RT::-1}" -ge 20 ];
    then
        break
    else
        echo "El tamaño de la particion root debe tener al menos 20 GiB."
        continue
    fi
done
sgdisk -n 2:0:+"$RT" "$DISCO"

while :
do
    read -rp "Indique el tamaño de la particion SWAP (Ej.: 10G): " SP
    if [ "${SP: -1}" != "G" ]; 
    then
        echo "La unidad de medida debe ser en GiB indicandolo con una 'G' al final del valor."
        continue
    fi
    if [ "${SP::-1}" -ge 4 ];
    then
        break
    else
        echo "El tamaño de la particion swap debe tener al menos 4 GiB."
        continue
    fi
done
sgdisk -n 3:0:+"$SP" "$DISCO"

while :
do
    read -rp "Indique el tamaño de la particion HOME (Ej.: 20G o 0 para el resto del disco): " HM
    if [ "${HM}" -eq 0 ] 2>/dev/null;
    then 
        sgdisk -n 4:0:0     "$DISCO"
        break
    elif [ "${HM: -1}" != "G" ]; 
    then
        echo "La unidad de medida debe ser en GiB indicandolo con una 'G' al final del valor."
        continue
    elif [ "${HM::-1}" -ge 1 ];
    then
        sgdisk -n 4:0:+"$HM" "$DISCO"
        break
    fi
done

# set partition types
sgdisk -t 1:ef00 "$DISCO"
sgdisk -t 2:8300 "$DISCO"
sgdisk -t 3:8200 "$DISCO"
sgdisk -t 4:8300 "$DISCO"

# Formateo
mkfs.fat -F32 "${DISCO}1"
mkfs.ext4 "${DISCO}2"
mkfs.ext4 "${DISCO}4"
mkswap "${DISCO}3"

# Montaje sistema de archivos
swapon "${DISCO}3"
mount "${DISCO}2" /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mkdir /mnt/home
mount "${DISCO}1" /mnt/boot/efi
mount "${DISCO}4" /mnt/home

# Instalacion
echo -e "\nPacstrap.\n"
pacstrap /mnt base base-devel linux linux-firmware vi nano openssh git reflector rsync

# FSTAB
echo -e "\nFSTAB.\n"
genfstab -U /mnt >> /mnt/etc/fstab

# CHROOT
chmod +x 1_chroot.sh
chmod +x 2_config_sys.sh
chmod +x 3_desktop_wm_install.sh
chmod +x 4_apps.sh
chmod +x 5_config_desktop.sh
chmod +x 6_limpieza.sh
cp 1_chroot.sh /mnt
echo -e "\nCHROOT.\n"
arch-chroot /mnt ./1_chroot.sh

# Copiar archivos de instalacion y configuracion
cp 2_config_sys.sh /mnt/root
cp 3_desktop_wm_install.sh /mnt/root
cp 4_apps.sh /mnt/root
cp 5_config_desktop.sh /mnt/root
cp 6_limpieza.sh /mnt/root

# Apagado
umount -R /mnt
poweroff