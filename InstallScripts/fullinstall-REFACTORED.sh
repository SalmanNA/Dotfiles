#!/usr/bin/env bash
#
# install-dotfiles.sh — Automated or manual Arch Linux setup
# Usage: install-dotfiles.sh [-m] [-b]
#   -m    Manual mode (default is automatic)
#   -b    Skip backing up existing ~/.config
#

set -euo pipefail
IFS=$'\n\t'

# --- Configuration ----------------------------------------------------------
DOTFILES_DIR="${HOME}/Dotfiles"
BACKUP_DIR="${HOME}/.config_backup"
PACKAGES_AUTOMATIC=(reactor rsync python-pywal16 swww waybar swaync starship neovim python-pywalfox hypridle hyprpicker hyprshot hyprlock pyprland wlogout fd cava brightnessctl clock-rs-git nerd-fonts nwg-look qogir-icon-theme materia-gtk-theme illogical-impulse-bibata-modern-classic-bin thunar kitty gvfs tumbler eza bottom htop libreoffice-fresh code blueman bluez pipewire pipewire-pulse pipewire-alsa pipewire-jack pavucontrol pulsemixer gnome-network-displays gst-plugins-bad hyprpolkitagent xorg-xhost vesktop filelight steam)
PACKAGES_COMMON=(python-pywal16 swww waybar swaync starship myfetch neovim python-pywalfox hypridle hyprpicker hyprshot hyprlock pyprland wlogout fd cava brightnessctl clock-rs-git nerd-fonts nwg-look qogir-icon-theme materia-gtk-theme illogical-impulse-bibata-modern-classic-bin thunar gvfs tumbler eza bottom htop libreoffice-fresh spotify ncspot discord code)

# --- Helpers ---------------------------------------------------------------
log()   { echo "[INFO] $*"; }
err()   { echo "[ERROR] $*" >&2; exit 1; }
command_exists() { command -v "$1" &>/dev/null; }

# --- Functions -------------------------------------------------------------
backup_config() {
  if [[ -d "${HOME}/.config" ]]; then
    log "Backing up ~/.config → ${BACKUP_DIR}"
    cp -a "${HOME}/.config" "${BACKUP_DIR}"
  else
    log "No existing ~/.config to backup"
  fi
}

install_yay() {
  if ! command_exists yay; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
  else
    log "yay already installed"
  fi
}

setup_reflector() {
  sudo pacman -S --needed --noconfirm reflector rsync
  sudo reflector --country 'US' --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
}

install_packages() {
  local mode="$1" pkg
  if [[ "$mode" == "auto" ]]; then
    PACKAGES=("${PACKAGES_AUTOMATIC[@]}")
  else
    PACKAGES=("${PACKAGES_COMMON[@]}")
  fi

  for pkg in "${PACKAGES[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null || yay -Qi "$pkg" &>/dev/null; then
      log "$pkg is already installed"
    else
      log "Installing $pkg"
      yay -S --noconfirm "$pkg"
    fi
  done
}

configure_services() {
  log "Enabling Bluetooth"
  sudo systemctl enable bluetooth

  log "Enabling PipeWire for user"
  systemctl --user enable --now pipewire{,-pulse}.service

  log "Enabling avahi-daemon"
  sudo systemctl enable avahi-daemon
}

install_zsh_and_omz() {
  # 1) Install Zsh
  sudo pacman -Syu --noconfirm zsh

  # 2) Clone & install Oh My Zsh unattended
  if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git "${HOME}/.oh-my-zsh"
    bash "${HOME}/.oh-my-zsh/tools/install.sh" --unattended
  fi

  # 3) Ensure Zsh is a valid login shell and switch to it
  grep -qxF '/bin/zsh' /etc/shells || echo '/bin/zsh' | sudo tee -a /etc/shells
  chsh -s "$(which zsh)" "$USER"

  # 4) Copy configs into Dotfiles
  mkdir -p "${DOTFILES_DIR}"
  cp -a "${HOME}/.zshrc" "${DOTFILES_DIR}/.zshrc"
  cp -a "${HOME}/.oh-my-zsh" "${DOTFILES_DIR}/.oh-my-zsh"
}

deploy_dotfiles() {
  log "Copying wallpapers and config"
  cp -a "${DOTFILES_DIR}/wallpapers" "${HOME}/"
  cp -a "${DOTFILES_DIR}/.config/." "${HOME}/.config/"
  cp -a "${DOTFILES_DIR}/.${SHELL##*/}rc" "${HOME}/"
}

set_wallpaper() {
  wal -i "${DOTFILES_DIR}/wallpapers/pywallpaper.jpg" -n
}

notify_user() {
  notify-send "Dotfiles Installed" "Open a terminal with MOD+Q\n– EF"
}

# --- Argument Parsing ------------------------------------------------------
MODE="auto"; BACKUP="yes"
while getopts ":mb" opt; do
  case $opt in
    m) MODE="manual" ;;
    b) BACKUP="no" ;;
    *) err "Usage: $0 [-m] [-b]";;
  esac
done

# --- Main ------------------------------------------------------------------
log "Starting installation in ${MODE} mode"

if [[ "${BACKUP}" == "yes" ]]; then
  backup_config
fi

install_yay
setup_reflector
install_packages "${MODE}"
configure_services
set_wallpaper
deploy_dotfiles
install_zsh_and_omz
notify_user

log "All done!"
exit 0

