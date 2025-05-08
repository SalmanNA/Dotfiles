#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Enable dot‑glob so * includes files beginning with “.”
shopt -s dotglob  # include hidden files in globs 

# Where to collect configs
DOTFILES_DIR="${HOME}/Dotfiles/.config"
mkdir -p "${DOTFILES_DIR}"   # idempotent directory creation 

# List of config directories under ~/.config to collect
CONFIG_ITEMS=(
  cava
  clock-rs
  hypr
  kitty
  nvim
  swaync
  wal
  waybar
  wlogout
  wofi
)

echo "[INFO] Collecting config items into ${DOTFILES_DIR}"

# Copy each config directory (if it exists)
for name in "${CONFIG_ITEMS[@]}"; do
  SRC="${HOME}/.config/${name}"
  DEST="${DOTFILES_DIR}/${name}"
  if [[ -e "${SRC}" ]]; then
    mkdir -p "${DEST}" 
    cp -a "${SRC}/." "${DEST}/"   # preserve attributes 
    echo " → Copied ${SRC} → ${DEST}"
  else
    echo " [WARN] ${SRC} not found, skipping"
  fi
done

# Copy starship.toml if present
STARSHIP_SRC="${HOME}/.config/starship.toml"
if [[ -f "${STARSHIP_SRC}" ]]; then
  cp -a "${STARSHIP_SRC}" "${DOTFILES_DIR}/starship.toml"
  echo " → Copied ${STARSHIP_SRC}"
else
  echo " [WARN] ${STARSHIP_SRC} not found, skipping"
fi

# --- NEW: also collect ~/.zshrc ---
ZSHRC_SRC="${HOME}/.zshrc"
if [[ -f "${ZSHRC_SRC}" ]]; then
  cp -a "${ZSHRC_SRC}" "${HOME}/Dotfiles/.zshrc"
  echo " → Copied ${ZSHRC_SRC} → ${HOME}/Dotfiles/.zshrc"
else
  echo " [WARN] ${ZSHRC_SRC} not found, skipping"
fi

# NEW: Copy the entire ~/.oh-my-zsh directory
OHMY_SRC="${HOME}/.oh-my-zsh"
if [[ -d "${OHMY_SRC}" ]]; then
  DEST="${HOME}/Dotfiles/.oh-my-zsh"
  mkdir -p "${DEST}"
  cp -a "${OHMY_SRC}/." "${DEST}/"  # copy all themes, plugins, etc. :contentReference[oaicite:3]{index=3}
  echo " → Copied ${OHMY_SRC} → ${DEST}"
else
  echo " [WARN] ${OHMY_SRC} not found, skipping"
fi

echo "[DONE] All specified configs (including .zshrc) have been collected."

