#!/bin/bash
sudo chmod -R 777 $HOME
yay -S reflector rsync
sudo reflector --country 'US' --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
yay -S pywal swww
wal -i ~/Dotfiles/wallpapers/walls/r82.jpg -n
yay -S waybar swaync starship myfetch neovim python-pywalfox hypridle hyprpicker hyprshot hyprlock pyprland wlogout fd cava brightnessctl clock-rs-git
yay -S nerd-fonts
yay -S nwg-look qogir-icon-theme materia-gtk-theme illogical-impulse-bibata-modern-classic-bin
yay -S thunar gvfs tumbler eza bottom htop
yay -S libreoffice-fresh
yay -S spotify ncspot discord code
yay -S blueman bluez
systemctl enable bluetooth
yay -S pipewire pipewire-pulse pipewire-alsa pipewire-jack pavucontrol pulsemixer 
systemctl --user enable pipewire.service pipewire-pulse.service
systemctl --user start pipewire.service pipewire-pulse.service
yay -S gnome-network-displays gst-plugins-bad
sudo systemctl enable avahi-daemon
hyprpm add https://github.com/virtcode/hypr-dynamic-cursors
hyprpm enable dynamic-cursors
sudo cp -f -r ~/Dotfiles/wallpapers ~/
sudo cp -r -f ~/Dotfiles/.config/* ~/.config/
sudo cp -r -f ~/Dotfiles/.bashrc ~/
notify-send "Open Terminal with MOD+Q" "Hello $USER,\nThank you for downloading my Dotfiles\n-EF"
