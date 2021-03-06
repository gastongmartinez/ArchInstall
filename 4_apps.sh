#!/usr/bin/env bash

read -rp "Ingrese el nombre del usuario perteneciente al grupo wheel: " USUARIO

read -rp "Instalar virtualizacion? (S/N): " VIRT

############################### Pacman ################################
PACMANPKGS=(
    #### Compresion ####
    'file-roller'
    'p7zip'
    'unrar'
    'unzip'
    'zip'

    #### Fuentes ####
    'terminus-font'
    'ttf-roboto'
    'ttf-roboto-mono'
    'ttf-dejavu'
    'powerline-fonts'
    'ttf-ubuntu-font-family'
    'ttf-font-awesome'
    'ttf-cascadia-code'

    #### WEB ####
    'wget'
    'curl'
    'chromium'
    'firefox'
    'thunderbird'
    'remmina'
    'qbittorrent'

    #### Shells ####
    'bash-completion'
    'fish'
    'zsh'
    'zsh-theme-powerlevel10k'
    'zsh-autosuggestions'
    'zsh-syntax-highlighting'
    'dialog'
    'shellcheck'

    #### Terminales ####
    'alacritty'

    #### Archivos ####
    'fd'
    'mc'
    'doublecmd-gtk2'
    'vifm'
    'fzf'
    'meld'
    'stow'
    'ripgrep'
    'exfat-utils'
    'autofs'
    'ntfs-3g'

    #### Sistema ####
    'ntp'
    'conky'
    'htop'
    'bashtop'
    'neofetch'
    'man'
    'os-prober'
    'pkgfile'
    'lshw'
    'plank'
    'powerline'
    'flameshot'
    'ktouch'
    
    #### Editores ####
    'vim'
    'neovim'
    'emacs'
    'code'
    'libreoffice-fresh'
    'libreoffice-fresh-es'

    #### Multimedia ####
    'vlc'
    'clementine'
    'mpv'

    #### Juegos ####
    'chromium-bsu'
    
    #### Redes ####
    'gufw'
    'nmap'
    'wireshark-qt'
    'inetutils'
    'dnsutils'
    'avahi'
    'nfs-utils'
    'nss-mdns'

    #### Diseño ####
    'gimp'
    'inkscape'
    'krita'
    'blender'
    'freecad'

    #### DEV ####
    'the_silver_searcher'
    'git'
    'gcc'
    'clang'
    'codeblocks'
    'filezilla'
    'go'
    'rust'
    'python'
    'python-pip'
    'jdk-openjdk'
    'pycharm-community-edition'
    'intellij-idea-community-edition'
    'nodejs'
    'npm'
    #'netbeans'
    #'stack'
    #'cabal-install'
    #'ghc'
)

# Instalacion de paquetes desde los repositorios de Arch 
for PAC in "${PACMANPKGS[@]}"; do
    pacman -S "$PAC" --noconfirm --needed
done

#######################################################################

############################ Virtualización ###########################
if [ "$VIRT" == 'S' ]; then
    PAQUETES=(
        'virt-manager'
        'qemu'
        'qemu-arch-extra'
        'ovmf'
        'ebtables'
        'vde2'
        'dnsmasq'
        'bridge-utils'
        'openbsd-netcat'
        'virtualbox'
    )
    for PAQ in "${PAQUETES[@]}"; do
        pacman -S "$PAQ" --noconfirm --needed
    done

    # Activacion libvirt para KVM
    systemctl enable libvirtd
    usermod -G libvirt -a "$USUARIO"
fi

#######################################################################

################# Instalacion de paquetes desde AUR ###################
su - "$USUARIO" <<EOF
    AURPKGS=(
        'pamac-aur'
        'brave-bin'
        'zenmap'
        #'nerd-fonts-complete'
        'autojump'
        'lf'
        'ttf-ms-fonts'
        'ttf-iosevka'
        'ttf-firacode'
        'font-manager'
    )
    for AUR in "${AURPKGS[@]}"; do
        paru -S "$AUR" --noconfirm --needed
    done
EOF
#######################################################################

################### Activacion de sercicios ###########################
systemctl enable avahi-daemon
#######################################################################