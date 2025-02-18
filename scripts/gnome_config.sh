#!/bin/bash
source ./_variables.sh

# Inherit exported variables from parent script
source ./_packages.sh
GNOME_PKGS=($GNOME_PKGS)

# Optional GNOME config functions
print_separator "Restoring GNOME config"
if confirm "Do you want to restore the gnome config?"; then
  dconf load / <"$HOME/Dotfiles/gnome-settings-backup.dconf"
fi

print_separator "Installing additional packages for GNOME"
if confirm "Do you want to install the listed packages for GNOME?"; then
  for pkg in "${GNOME_PKGS[@]}"; do
    echo_arrow "Checking $pkg..."

    if pacman -Q "$pkg" &>/dev/null; then
      echo_success "$pkg is already installed"
    else
      echo_arrow "Installing $pkg..."

      if yay -S --noconfirm --quiet "$pkg" >/dev/null 2>&1; then
        echo_success "$pkg installed"
      else
        echo_error "$pkg not installed"
      fi
    fi
  done
fi
