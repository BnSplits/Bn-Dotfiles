#!/bin/bash
source ./_variables.sh

# Special ways to install some packages
print_separator "Special installation precess"

# Tmux tpm
if confirm "Do you want to install tpm (Tmux)?"; then
  echo_arrow "Tpm installation..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Spicetify
if confirm "Do you want to install Spicetify?"; then
  echo_arrow "Installation of Spicetify..."
  curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
fi

# Hyprls (Hyprland LSP)
if confirm "Do you want to install Hyprls (Hyprland LSP)?"; then
  git clone --recurse-submodules https://github.com/hyprland-community/hyprls /tmp/hyprls &&
    (cd /tmp/hyprls && just install)
fi

# Papirus icons
if confirm "Do you want to install papirus icon theme?"; then
  if confirm "  On root directory?"; then
    wget -qO- https://git.io/papirus-icon-theme-install | sh
  fi
  if confirm "  On HOME directory for GTK?"; then
    wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.icons" sh
  fi
  if confirm "  On HOME directory for KDE?"; then
    wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.local/share/icons" sh
  fi
fi
