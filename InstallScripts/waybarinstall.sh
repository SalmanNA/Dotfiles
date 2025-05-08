#!/bin/bash
yay -S waybar hyprpicker otf-codenewroman-nerd pywal
wal -i ~/Dotfiles/wallpapers/pywallpaper.jpg
yay -S blueman bluez 
systemctl enable bluetooth
sudo cp -a ~/Dotfiles/.config/waybar ~/.config/
