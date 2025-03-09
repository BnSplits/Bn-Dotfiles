#!/bin/bash
source ./_variables.sh

# Inherit exported variables from parent script
source ./_packages.sh
HYPR_PKGS=($HYPR_PKGS)

# Hyprland Configuration
print_separator "Configuring Hyprland"
if confirm "Do you want to install Hyprland packages?"; then
  yay -Sy
  for pkg in "${HYPR_PKGS[@]}"; do
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

  if confirm "Do you want to install some plugins?"; then
    echo_arrow "Installing plugins"
    hyprpm update
    hyprpm add https://github.com/hyprwm/hyprland-plugins
    hyprpm add https://github.com/virtcode/hypr-dynamic-cursors
    hyprpm reload -n

    hyprpm enable dynamic-cursors
    hyprpm enable hyprexpo
  fi

  echo_arrow "Installing papirus-folders"
  wget -qO- https://git.io/papirus-folders-install | env PREFIX=$HOME/.local sh

  sudo systemctl enable NetworkManager
  sudo systemctl start NetworkManager
fi
