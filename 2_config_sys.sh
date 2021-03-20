#!/usr/bin/env bash

# Habilitar Wheel en Sudoers
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' "/etc/sudoers"

# Habilitar multilib
sed -i 's/#\[multilib\]/\[multilib\]\nInclude = \/etc\/pacman.d\/mirrorlist/g' "/etc/pacman.conf"
pacman -Syu --noconfirm

# MirrorList
echo -e "\nActualizando mirrorlist\n"
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.OLD
reflector --verbose --latest 25 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syu

# Usuario
pacman -S xdg-user-dirs xdg-utils --noconfirm
echo -e "\nCreacion de usuario (sera incluido en el grupo wheel).\n"
read -rp "Ingrese el nombre del usuario: " USUARIO
read -rp "Ingrese el nombre completo del usuario: " NOMBRE
useradd -m -g users -G wheel -s /bin/bash -c "$NOMBRE" "$USUARIO"
echo -e "\nIngresar password para el usuario $USUARIO\n"
passwd "$USUARIO"

# Swappiness
echo -e "vm.swappiness=10\n" >> /etc/sysctl.d/99-sysctl.conf

#######################  Hardware & Drivers  #######################
echo -e "\nSeleccion de paquetes para el hardware del equipo.\n"
# Wifi
read -rp "Desea instalar WPA Supplicant (S/N): " WIFI
if [ "$WIFI" == "S" ];
then
    pacman -S wpa_supplicant --noconfirm
fi

# Bluetooth
read -rp "Desea instalar Bluetooth (S/N): " BT
if [ "$BT" == "S" ];
then
    pacman -S bluez --noconfirm
    pacman -S bluez-utils --noconfirm
    systemctl enable bluetooth
fi

# SSD
read -rp "Se instala en un SSD (S/N): " SSD
if [ "$SSD" == "S" ];
then
    pacman -S util-linux --noconfirm
    systemctl enable fstrim.service
    systemctl enable fstrim.timer
fi

# Microcode

read -rp "Instalar microcode I=Intel - A=AMD: " MC
if [ "$MC" == "A" ];
then
    pacman -S amd-ucode --noconfirm
else
    pacman -S intel-ucode --noconfirm
fi

# Actualizar Grub
grub-mkconfig -o /boot/grub/grub.cfg

# Hardware
read -rp "Se instala en maquina virtual (S/N): " MV
if [ "$MV" == "S" ];
then
    read -rp "Indicar plataforma virtual 1=VirtualBox - 2=VMWare: " PLAT
    if [ "$PLAT" -eq 1 ] 2>/dev/null;
    then
        # VirtualBox Guest utils
        pacman -S virtualbox-guest-utils --noconfirm
    else
        # Open-VM-Tools (WMWare)
        pacman -S open-vm-tools --noconfirm
        pacman -S xf86-video-vmware --noconfirm
        systemctl enable vmware-vmblock-fuse.service
        systemctl enable vmtoolsd.service
    fi
fi

# Audio
pacman -S alsa-utils --noconfirm
pacman -S pulseaudio --noconfirm
pacman -S pulseaudio-bluetooth --noconfirm

# Video
read -rp "Instalar drivers de Video AMD (S/N): " VAMD
if [ "$VAMD" == "S" ];
then
    pacman -S xf86-video-amdgpu --noconfirm
fi
read -rp "Instalar drivers de Video Intel (S/N): " VINT
if [ "$VINT" == "S" ];
then
    pacman -S xf86-video-intel --noconfirm
fi

# Touchpad
read -rp "Instalar drivers para touchpad (S/N): " TOUCH
if [ "$TOUCH" == "S" ];
then
    pacman -S xf86-input-libinput --noconfirm
fi

# PowerManagement
read -rp "Instalar PowerMangement (S/N): " PM
if [ "$PM" == "S" ];
then
    pacman -S tlp --noconfirm 
    pacman -S powertop --noconfirm
    systemctl enable tlp          
fi

# ACPI 
read -rp "Instalar ACPI (S/N): " AC
if [ "$AC" == "S" ];
then   
    pacman -S acpi --noconfirm 
    pacman -S acpi_call --noconfirm
    pacman -S acpid --noconfirm
    systemctl enable acpid     
fi
####################################################################

###########################  XORG  #################################
pacman -S xorg --noconfirm
pacman -S xorg-apps --noconfirm
pacman -S xorg-xinit --noconfirm
pacman -S xterm --noconfirm
####################################################################

# PARU
su - "$USUARIO" <<EOF
    cd /tmp
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
EOF

# Wallpapers
git clone https://github.com/gastongmartinez/wallpapers.git
mv wallpapers /usr/share/backgrounds/

# Tema Grub
pacman -S grub-theme-vimix --noconfirm
echo -e '\nGRUB_THEME="/usr/share/grub/themes/Vimix/theme.txt"' >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

reboot