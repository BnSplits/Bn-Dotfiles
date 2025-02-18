#!/bin/bash
source ./_variables.sh

# Inherit exported variables from parent script
source ./_packages.sh
UNINSTALL_PKGS=($UNINSTALL_PKGS)

# Uninstall packages with cleaner output
print_separator "Uninstalling packages"
if confirm "Do you want to uninstall the listed packages?"; then
  for pkg in "${UNINSTALL_PKGS[@]}"; do
    echo_arrow "Checking $pkg..."

    if ! pacman -Q "$pkg" &>/dev/null; then
      echo_success "$pkg is not installed"
    else
      echo_arrow "Uninstalling $pkg..."

      if yay -Rns --noconfirm "$pkg" >/dev/null 2>&1; then
        echo_success "$pkg uninstalled"
      else
        echo_error "$pkg not uninstalled"
      fi
    fi
  done
fi
