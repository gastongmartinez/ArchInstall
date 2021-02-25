#!/usr/bin/env bash

#!/bin/bash
if [ $EUID -eq 0 ];
then
   echo "Este script debe usarse con un usuario regular."
   echo "Saliendo..."
   exit 1
fi

gnome () {
    # Establecer valores usando gsettings o dconf write
    # gsettings set org.gnome.desktop.interface gtk-theme 'Qogir-manjaro-win-dark'
    # dconf write /org/gnome/desktop/interface/gtk-theme "'Qogir-manjaro-win-dark'"

    ############################################## Extensiones ##################################################################################
    # ArcMenu
    dconf write /org/gnome/shell/enabled-extensions "['arcmenu@arcmenu.com']"
    dconf write /org/gnome/shell/extensions/arcmenu/available-placement "[true, false, false]"
    dconf write /org/gnome/mutter/overlay-key "'Super_L'"
    dconf write /org/gnome/desktop/wm/keybindings/panel-main-menu "['<Alt>F1']"
    dconf write /org/gnome/shell/extensions/arcmenu/pinned-app-list "['Web', '', 'org.gnome.Epiphany.desktop', 'Terminal', '', 'org.gnome.Terminal. desktop', 'ArcMenu Settings', 'ArcMenu_ArcMenuIcon', 'gnome-extensions prefs arcmenu@arcmenu.com']"
    dconf write /org/gnome/shell/extensions/arcmenu/menu-hotkey "'Super_L'"
    # Pop Shell
    dconf write /org/gnome/shell/enabled-extensions "['arcmenu@arcmenu.com', 'pop-shell@system76.com']"
    # User themes
    dconf write /org/gnome/shell/enabled-extensions "['arcmenu@arcmenu.com', 'pop-shell@system76.com', 'user-theme@gnome-shell-extensions.gcampax.  github.com']"
    # Dash to Dock
    dconf write /org/gnome/shell/enabled-extensions "['arcmenu@arcmenu.com', 'pop-shell@system76.com', 'user-theme@gnome-shell-extensions.gcampax.  github.com', 'drop-down-terminal@gs-extensions.zzrough.org', 'dash-to-dock@micxgx.gmail.com']"
    dconf write /org/gnome/shell/extensions/arcmenu/available-placement "[false, false, true]"
    dconf write /org/gnome/shell/extensions/dash-to-dock/preferred-monitor 0
    dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'BOTTOM'"
    dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed false
    dconf write /org/gnome/shell/extensions/dash-to-dock/autohide true
    dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash false
    dconf write /org/gnome/shell/extensions/dash-to-dock/show-show-apps-button false
    dconf write /org/gnome/shell/extensions/dash-to-dock/transparency-mode "'DYNAMIC'"
    dconf write /org/gnome/shell/extensions/dash-to-dock/customize-alphas true
    dconf write /org/gnome/shell/extensions/dash-to-dock/min-alpha 0.10
    dconf write /org/gnome/shell/extensions/dash-to-dock/max-alpha 0.60
    # Pamac
    dconf write /org/gnome/shell/enabled-extensions "['arcmenu@arcmenu.com', 'pop-shell@system76.com', 'user-theme@gnome-shell-extensions.gcampax.  github.com', 'drop-down-terminal@gs-extensions.zzrough.org', 'dash-to-dock@micxgx.gmail.com', 'pamac-updates@manjaro.org']"
    # Drop down Terminal
    dconf write /org/gnome/shell/enabled-extensions "['arcmenu@arcmenu.com', 'pop-shell@system76.com', 'user-theme@gnome-shell-extensions.gcampax.  github.com', 'dash-to-dock@micxgx.gmail.com', 'pamac-updates@manjaro.org', 'drop-down-terminal@gs-extensions.zzrough.org',    'drop-down-terminal-x@bigbn.pro']"
    dconf write /pro/bigbn/drop-down-terminal-x/other-shortcut "['F12']"
    dconf write /pro/bigbn/drop-down-terminal-x/enable-tabs true
    dconf write /pro/bigbn/drop-down-terminal-x/use-default-colors true
    ##############################################################################################################################################

    # Tema
    dconf write /org/gnome/desktop/interface/gtk-theme "'Prof-Gnome-Dark'"
    dconf write /org/gnome/shell/extensions/user-theme/name "'Prof-Gnome-Dark'"
    dconf write /org/gnome/desktop/interface/cursor-theme "'Qogir-manjaro-dark'"
    dconf write /org/gnome/desktop/interface/icon-theme "'Qogir-manjaro-dark'"

    # Wallpaper
    dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/Landscapes/landscapes%2023.jpg'"

    # Establecer fuentes
    dconf write /org/gnome/desktop/interface/font-name "'Ubuntu 11'"
    dconf write /org/gnome/desktop/interface/document-font-name "'Ubuntu 11'"
    dconf write /org/gnome/desktop/interface/monospace-font-name "'Ubuntu Mono 10'"
    dconf write /org/gnome/desktop/wm/preferences/titlebar-font "'Ubuntu Bold 11'"

    # Aplicaciones favoritas
    dconf write /org/gnome/shell/favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Boxes.desktop', 'org.gnome. Evolution.desktop', 'libreoffice-calc.desktop', 'chromium.desktop', 'firefox.desktop', 'brave-browser.desktop', 'org.qbittorrent.qBittorrent.    desktop', 'code-oss.desktop', 'codeblocks.desktop', 'Alacritty.desktop', 'clementine.desktop', 'vlc.desktop', 'org.gnome.tweaks.desktop']"

    # Suspender
    # En 2 horas enchufado
    dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-timeout 7200
    # En 30 minutos con bateria
    dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-timeout 1800

    # Autostart Apps
    #if [ ! -d ~/.config/autostart ]; then
    #    mkdir -p ~/.config/autostart
    #fi
    #cp /usr/share/applications/plank.desktop ~/.config/autostart/    
}

mate () {
    # Tema
    #gsettings set org.mate.interface gtk-theme 'Nordic'
    gsettings set org.mate.interface gtk-theme 'Qogir-manjaro-win-dark'
    gsettings set org.mate.Marco.general theme 'Qogir-manjaro-dark'
    gsettings set org.mate.interface icon-theme 'Qogir-manjaro-dark'
    gsettings set org.mate.peripherals-mouse cursor-theme 'Qogir-manjaro-dark'

    # Remover panel inferior
    dconf write /org/mate/panel/general/toplevel-id-list "['top']"

    # Wallpaper
    #gsettings set org.mate.background picture-filename "/SOME/PATH/IMAGE.jpg"

    # Caja: vista de detalles
    gsettings set org.mate.caja.preferences default-folder-viewer 'list-view'

    # Habilitar Delete en Caja
    gsettings set org.mate.caja.preferences enable-delete true

    # Habilitar archivos ocultos Caja
    gsettings set org.mate.caja.preferences show-hidden-files true

    # Iconos escritorio
    gsettings set org.mate.caja.desktop computer-icon-visible false
    gsettings set org.mate.caja.desktop home-icon-visible false
    gsettings set org.mate.caja.desktop trash-icon-visible false
    #gsettings set org.mate.caja.desktop volumes-visible false

    # Remover menu Mate
    gsettings set org.mate.panel.menubar show-applications false
    gsettings set org.mate.panel.menubar show-desktop false
    gsettings set org.mate.panel.menubar show-icon false
    gsettings set org.mate.panel.menubar show-places false

    # Agregar Brisk-Menu
    dconf write /org/mate/panel/objects/object-0/object-type "'applet'"
    dconf write /org/mate/panel/objects/object-0/panel-right-stick false
    dconf write /org/mate/panel/objects/object-0/position 0
    dconf write /org/mate/panel/objects/object-0/toplevel-id "'top'"
    dconf write /org/mate/panel/objects/object-0/applet-iid "'BriskMenuFactory::BriskMenu'"
    dconf write /org/mate/panel/general/object-id-list "['notification-area', 'clock', 'show-desktop', 'window-list', 'workspace-switcher',     'object-0']"

    # Establecer fuentes
    dconf write /org/mate/desktop/interface/font-name "'Ubuntu 10'"
    dconf write /org/mate/desktop/interface/document-font-name "'Ubuntu 10'"
    dconf write /org/mate/caja/desktop/font "'Ubuntu 10'"
    dconf write /org/mate/marco/general/titlebar-font "'Ubuntu 10'"
    dconf write /org/mate/desktop/interface/monospace-font-name "'Ubuntu Mono 10'"

    # Notificaciones
    dconf write /org/mate/notification-daemon/theme "'coco'"

    # Autostart
    if [ ! -d ~/.config/autostart ]; 
    then
        mkdir -p ~/.config/autostart
    fi
    PLANK=/usr/share/applications/plank.desktop
    if [ -f "$PLANK" ]; 
    then 
        cp "$PLANK" ~/.config/autostart/
    fi
}

doom () {
    cd ~
    if [ -d ~/.emacs.d ]; 
    then
        rm -Rf ~/.emacs.d
    fi
    git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
}

CONFIGURAR="GNOME Mate DoomEmacs Salir"
echo -e "\nElija que configurar:"
select conf in $CONFIGURAR;
do
    if [ $conf == "GNOME" ];
    then
        echo -e "\nConfigurando $conf"
        sleep 2
        gnome
    elif [ $conf == "Mate" ];
    then
        echo -e "\nConfigurando $conf"
        sleep 2
        mate
    elif [ $conf == "DoomEmacs" ];
    then
        echo -e "\nConfigurando $conf"
        sleep 2
        doom
    else
        echo "Salir"
        break
    fi
    echo -e "\nElija el escritorio a configurar:"
    REPLY=""
done