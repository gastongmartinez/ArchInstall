#!/usr/bin/env bash

################################# LIGHTDM ##########################################
lightdm () {
    read -rp "Desea instalar Lightdm (S/N): " LDM
    if [ "$LDM" == "S" ];
    then
        pacman -S lightdm --noconfirm
        pacman -S lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm

        ### Slick Greeter ###
        su - "$USUARIO" <<EOF
            paru -S lightdm-slick-greeter --noconfirm
            paru -S lightdm-settings --noconfirm
EOF

        sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/g' "/etc/lightdm/lightdm.conf"
        systemctl enable lightdm.service
    fi
}
##################################################################################

################################### SDDM #########################################
sddm () {
    pacman -S sddm sddm-kcm --noconfirm
    systemctl enable sddm.service
}    
##################################################################################

################################ Temas GTK #######################################
prof_gnome () {
    su - "$USUARIO" <<EOF
        paru -S prof-gnome-theme-git --noconfirm
EOF
}

qogir () {
    su - "$USUARIO" <<EOF
    paru -S qogir-icon-theme --noconfirm
    paru -S qogir-gtk-theme  --noconfirm
EOF
}

whitesur () {
    su - "$USUARIO" <<EOF
        paru -S whitesur-gtk-theme-git whitesur-icon-theme-git --noconfirm
        paru -S whitesur-cursor-theme-git --noconfirm
EOF
}

flat_remix () {
        su - "$USUARIO" <<EOF
            paru -S flat-remix flat-remix-gtk flat-remix-gnome --noconfirm
EOF
}

orchis () {
        su - "$USUARIO" <<EOF
            paru -S orchis-theme-git --noconfirm
EOF
}
    
nordic () {
        su - "$USUARIO" <<EOF
            paru -S nordic-theme --noconfirm
EOF
}


temas_gtk () {
    read -rp "Desea instalar temas GTK (S/N): " TGTK
    if [ "$TGTK" == "S" ];
    then
        TEMAS="Prof-Gnome Qogir WhiteSur Flat-Remix Orchis Nordic Salir"
        echo -e "\nSeleccione el tema a instalar:"
        select tema in $TEMAS;
        do
            if [ "$tema" == "Prof-Gnome" ];
            then
                echo -e "\nInstalando $tema"
                sleep 2
                prof_gnome
            elif [ "$tema" == "Qogir" ];
            then
                echo -e "\nInstalando $tema"
                sleep 2
                qogir
            elif [ "$tema" == "WhiteSur" ];
            then
                echo -e "\nInstalando $tema"
                sleep 2
                whitesur
            elif [ "$tema" == "Flat-Remix" ];
            then
                echo -e "\nInstalando $tema"
                sleep 2
                flat_remix
            elif [ "$tema" == "Orchis" ];
            then
                echo -e "\nInstalando $tema"
                sleep 2
                orchis
            elif [ "$tema" == "Nordic" ];
            then
                echo -e "\nInstalando $tema"
                sleep 2
                nordic
            else
                break
            fi
            echo -e "\nSeleccione el tema a instalar:"
            REPLY=""
        done    
    fi
}    
##################################################################################

################################# GNOME ############################################
gnome () {
    pacman -S gnome --noconfirm
    pacman -S gnome-extra --noconfirm
    pacman -S chrome-gnome-shell gnome-shell-extensions --noconfirm

    # GDM
    systemctl enable gdm

    temas_gtk

    # Extensiones
    su - "$USUARIO" <<EOF
        paru -S gnome-shell-extension-pop-shell --noconfirm
        paru -S gnome-shell-extension-arc-menu --noconfirm
        paru -S gnome-shell-extension-drop-down-terminal-x --noconfirm
        paru -S gnome-shell-extension-dash-to-dock --noconfirm
EOF

    read -rp "Desea desactivar Wayland (S/N): " WL
    if [ "$WL" == "S" ];
    then
        sed -i 's/#WaylandEnable=false/WaylandEnable=false/g' "/etc/gdm/custom.conf"
    fi
}
####################################################################################


################################## XFCE ############################################
xfce () {
    lightdm

    pacman -S xfce4 xfce4-goodies --noconfirm

    temas_gtk
}
####################################################################################

################################## MATE ############################################
mate () {
    lightdm

    pacman -S mate mate-extra --noconfirm
    pacman -S mate-applet-dock mate-common plank --noconfirm
    pacman -S mate-icon-theme mate-themes --noconfirm

    su - "$USUARIO" <<EOF
    # Mate tools
    paru -S mate-tweak brisk-menu --noconfirm
    paru -S gnome-system-tools --noconfirm
EOF

    temas_gtk
}
####################################################################################

################################### KDE ############################################
kde () {
    read -rp "Desea instalar SDDM (S/N): " DM
    if [ "$DM" == "S" ];
    then
        sddm
    fi

    pacman -S plasma kde-utilities --noconfirm
    pacman -S kde-graphics kde-system --noconfirm
    pacman -S krusader kdeconnect --noconfirm
    pacman -S kcron --noconfirm
    pacman -S knotes --noconfirm
    pacman -S kfind --noconfirm
    pacman -S kalarm --noconfirm
    pacman -S dolphin-plugins --noconfirm
    pacman -S yakuake --noconfirm
    #pacman -S kmymoney --noconfirm
    pacman -S kruler --noconfirm
    pacman -S kcolorchooser --noconfirm
    pacman -S ktouch --noconfirm
    pacman -S kdiff3 --noconfirm
    #pacman -S kdevelop --noconfirm
    #pacman -S kalgebra --noconfirm
    #pacman -S cantor --noconfirm
    pacman -S latte-dock --noconfirm

    su - "$USUARIO" <<EOF
        # Temas
        paru -S whitesur-kde-theme-git --noconfirm
        paru -S whitesur-icon-theme-git --noconfirm
        paru -S whitesur-cursor-theme-git --noconfirm
        paru -S qogir-kde-theme-git --noconfirm
EOF
}
####################################################################################

################################## WM General ######################################
wm_general () {
    pacman -S dmenu --noconfirm --needed
    pacman -S rofi --noconfirm --needed
    pacman -S nitrogen --noconfirm --needed
    pacman -S feh --noconfirm --needed
    pacman -S picom --noconfirm
    pacman -S lxappearance --noconfirm
}
####################################################################################

################################### AwesomeWM #######################################
awesomewm () {
    pacman -S awesome --noconfirm
    sleep 2
    sed -i 's/Name=awesome/Name=Awesome/g' "/usr/share/xsessions/awesome.desktop"
}
####################################################################################

################################### SpectrWM #######################################
spectrwm () {
    pacman -S spectrwm --noconfirm
    su - "$USUARIO" -c 'paru -S polybar --noconfirm'
}
####################################################################################

################################### Xmonad #########################################
xmonad () {
    pacman -S xmonad --noconfirm
    pacman -S xmonad-contrib --noconfirm
    pacman -S xmonad-utils --noconfirm
    pacman -S xmobar --noconfirm
}    
####################################################################################

##################################### I3 ###########################################
i3 () {
    pacman -S i3-gaps --noconfirm
    pacman -S i3status --noconfirm
    pacman -S i3lock --noconfirm
}
####################################################################################

################################### BSPWM ##########################################
bspwm () {
    pacman -S bspwm --noconfirm
    pacman -S sxhkd --noconfirm
    su - "$USUARIO" -c 'paru -S polybar --noconfirm'
}
####################################################################################

################################### Qtile ##########################################
qtile () {
    pacman -S qtile --noconfirm --needed
}
####################################################################################

################################## MENU ############################################
menu () {
    ##################### Escritorios ##########################
    ESCRITORIOS="GNOME XFCE Mate KDE Salir"
    echo -e "\nSeleccione el escritorio a instalar:"
    select escritorio in $ESCRITORIOS;
    do
        if [ "$escritorio" == "GNOME" ];
        then
            echo -e "\nInstalando $escritorio"
            sleep 2
            gnome
        elif [ "$escritorio" == "XFCE" ];
        then
            echo -e "\nInstalando $escritorio"
            sleep 2
            xfce
        elif [ "$escritorio" == "Mate" ];
        then
            echo -e "\nInstalando $escritorio"
            sleep 2
            mate
        elif [ "$escritorio" == "KDE" ];
        then
            echo -e "\nInstalando $escritorio"
            sleep 2
            kde
        else
            break
        fi
        echo -e "\nSeleccione el escritorio a instalar:"
        REPLY=""
    done
    ############################################################

    ######################## WM ################################
    read -rp "Desea instalar algun window manager (S/N): " WM
    if [ "$WM" == "S" ];
    then
        wm_general

        WINMS="SpectrWM Xmonad I3 BSPWM Qtile Awesome Salir"
        echo -e "\nSeleccione el window manager a instalar:"
        select winm in $WINMS;
        do
            if [ "$winm" == "SpectrWM" ];
            then
                echo -e "\nInstalando $winm"
                sleep 2
                spectrwm
            elif [ "$winm" == "Xmonad" ];
            then
                echo -e "\nInstalando $winm"
                sleep 2
                xmonad
            elif [ "$winm" == "I3" ];
            then
                echo -e "\nInstalando $winm"
                sleep 2
                i3
            elif [ "$winm" == "BSPWM" ];
            then
                echo -e "\nInstalando $winm"
                sleep 2
                bspwm
            elif [ "$winm" == "Qtile" ];
            then
                echo -e "\nInstalando $winm"
                sleep 2
                qtile
            elif [ "$winm" == "Awesome" ];
            then
                echo -e "\nInstalando $winm"
                sleep 2
                awesomewm
            else
                break
            fi
            echo -e "\nSeleccione el window manager a instalar:"
            REPLY=""
        done    
    fi
    ############################################################
}
####################################################################################


pacman -Syu

read -rp "Ingrese el nombre del usuario perteneciente al grupo wheel: " USUARIO

menu

# Script configuracion desktop
mv 5_config_desktop.sh /home/"$USUARIO"

# Teclado
localectl set-x11-keymap es pc105 winkeys

reboot

