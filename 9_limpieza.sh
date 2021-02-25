#!/usr/bin/env bash

if [ $EUID -ne 0 ];
then
   echo "Este script debe ejecutarse como root."
   echo "Saliendo..."
   exit 1
fi

read -p "Ingrese el nombre del usuario configurado: " USUARIO

rm -f /1_chroot.sh
rm -f /root/2_config_sys.sh
rm -f /root/3_desktop_wm_install.sh
rm -f /root/4_apps.sh
rm -f /home/"$USUARIO"/5_config_desktop.sh
rm -f "$0"
