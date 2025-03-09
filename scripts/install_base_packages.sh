#!/bin/bash
source ./_variables.sh

# Inherit exported variables from parent script
source ./_packages.sh
BASE_PKGS=($BASE_PKGS)

# Install base packages
print_separator "Installing base packages"
if confirm "Do you want to install base packages?"; then
  yay -Sy
  for pkg in "${BASE_PKGS[@]}"; do
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
