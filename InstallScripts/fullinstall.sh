#!/bin/bash
# Ask if they want automatic or manual installation
read -p "Do you want automatic (default) or manual installation? (a/m): " install_choice
install_choice=${install_choice:-a}  # Default to 'a' if empty
# Ask if they want to backup their .config
read -p "Do you want to backup your current .config directory? (y/n, default: y): " backup_choice
backup_choice=${backup_choice:-y}  # Default to 'y' if empty
if [[ "$backup_choice" == "y" ]]; then
    cp -r ~/.config ~/.config_backup
    echo "Backup of .config created at ~/.config_backup"
fi
# Automatic install section
if [[ $install_choice == "a" ]]; then
    sudo chmod -R 777 $HOME
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    yay -S reflector rsync python-pywal16 swww waybar swaync starship neovim python-pywalfox hypridle hyprpicker hyprshot hyprlock pyprland wlogout fd cava brightnessctl clock-rs-git nerd-fonts nwg-look qogir-icon-theme materia-gtk-theme illogical-impulse-bibata-modern-classic-bin thunar kitty gvfs tumbler eza bottom htop libreoffice-fresh code blueman bluez pipewire pipewire-pulse pipewire-alsa pipewire-jack pavucontrol pulsemixer gnome-network-displays gst-plugins-bad hyprpolkitagent xorg-xhost vesktop filelight steam 
    sudo reflector --country 'US' --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
    systemctl enable bluetooth
    systemctl --user enable pipewire.service
    systemctl --user enable pipewire-pulse.service
    systemctl --user start pipewire.service
    systemctl --user start pipewire-pulse.service
    xhost +si:localuser:root
    sudo systemctl enable avahi-daemon
    # Set wallpaper
    wal -i ~/Dotfiles/wallpapers/pywallpaper.jpg -n
    # Dynamic-Cursors setup
    hyprpm add https://github.com/virtcode/hypr-dynamic-cursors
    hyprpm enable dynamic-cursors
    # Copy files
    sudo cp -a ~/Dotfiles/wallpapers ~/
    sudo cp -a ~/Dotfiles/.config/* ~/.config/
    sudo cp -a ~/Dotfiles/.zshrc ~/
    notify-send "Open Terminal with MOD+Q" "Hello $USER,\nThank you for downloading my Dotfiles\n-EF"
# Manual install section
elif [[ $install_choice == "m" ]]; then
    sudo chmod -R 777 $HOME
    read -p "Do you want to change your mirrorlist to the best one for US? (y/n, default: y): " mirror_choice
    mirror_choice=${mirror_choice:-y}  # Default to 'y' if empty
    if [[ "$mirror_choice" == "y" ]]; then
        yay -S reflector rsync
        sudo reflector --country 'US' --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
    fi
        # Confirm each package installation
    for package in python-pywal16 swww waybar swaync starship myfetch neovim python-pywalfox hypridle hyprpicker hyprshot hyprlock pyprland wlogout fd cava brightnessctl clock-rs-git nerd-fonts nwg-look qogir-icon-theme materia-gtk-theme illogical-impulse-bibata-modern-classic-bin thunar gvfs tumbler eza bottom htop libreoffice-fresh spotify ncspot discord code; do
        read -p "Do you want to install $package? (y/n, default: y): " choice
        choice=${choice:-y}  # Default to 'y' if empty
        if [[ "$choice" == "y" ]]; then
            yay -S $package
            clear
        fi
    done
    wal -i ~/Dotfiles/wallpapers/pywallpaper.jpg -n
    # Ask for bluetooth
    read -p "Do you want to install Bluetooth support? (y/n, default: y): " bluetooth_choice
    bluetooth_choice=${bluetooth_choice:-y}  # Default to 'y' if empty
    if [[ "$bluetooth_choice" == "y" ]]; then
        yay -S blueman bluez
        systemctl enable bluetooth
    fi
    # Ask for Pipewire and Network Displays
    read -p "Do you want to configure Pipewire and Network Displays? (y/n, default: y): " pipewire_choice
    pipewire_choice=${pipewire_choice:-y}  # Default to 'y' if empty
    if [[ "$pipewire_choice" == "y" ]]; then
        yay -S pipewire pipewire-pulse pipewire-alsa pipewire-jack pavucontrol pulsemixer gnome-network-displays gst-plugins-bad
        systemctl --user enable pipewire.service
        systemctl --user enable pipewire-pulse.service
        systemctl --user start pipewire.service
        systemctl --user start pipewire-pulse.service
    fi
    # Dynamic-Cursors setup
    read -p "Do you want to enable Dynamic-Cursors? (y/n, default: y): " cursors_choice
    cursors_choice=${cursors_choice:-y}  # Default to 'y' if empty
    if [[ "$cursors_choice" == "y" ]]; then
        hyprpm add https://github.com/virtcode/hypr-dynamic-cursors
        hyprpm enable dynamic-cursors
    fi
    # Copy files
    sudo cp -a ~/Dotfiles/wallpapers ~/
    sudo cp -a ~/Dotfiles/.config/* ~/.config/
    sudo cp -a ~/Dotfiles/.bashrc ~/
    notify-send "Open Terminal with MOD+Q" "Hello $USER,\nThank you for downloading my Dotfiles\n-EF"
fi
