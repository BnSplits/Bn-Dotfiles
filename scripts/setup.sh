#!/bin/bash

clear

source ./_variables.sh
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# --- DIRECTORY CHECK ---
if [[ "$PWD" != "$SCRIPT_DIR" ]]; then
  echo -e "${RED}╔══════════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${RED}║  Be sure to be in the same directory as the script before launching it!  ║${NC}"
  echo -e "${RED}╚══════════════════════════════════════════════════════════════════════════╝${NC}"
  exit 1
fi
cd "$SCRIPT_DIR" || exit 1

# --- CHECKING FOR YAY ---
if ! command -v yay &>/dev/null; then
  echo_error "yay is not installed. Install yay before continuing."

  if confirm "Do you want to install yay?"; then
    YAY_DIR="/tmp/yay-$(date '+%Y-%m-%d_%H-%M-%S')"

    echo_arrow "Installing required dependencies..."
    sudo pacman -Syu --needed base-devel git || {
      echo_error "Failed to install dependencies."
      exit 1
    }

    echo_arrow "Cloning yay repository..."
    git clone --depth=1 https://aur.archlinux.org/yay.git "$YAY_DIR" || {
      echo_error "Failed to clone yay repository."
      exit 1
    }

    cd "$YAY_DIR" || {
      echo_error "Failed to enter directory: $YAY_DIR"
      exit 1
    }

    echo_arrow "Building and installing yay..."
    makepkg -si || {
      echo_error "Failed to build and install yay."
      exit 1
    }

    echo_success "yay has been successfully installed."
  else
    echo_error "Installation aborted by user."
    exit 1
  fi
  clear
fi

# --- CONFIGURATION STEPS ---
./config_clock.sh
./update_db.sh
./uninstall_packages.sh
./install_base_packages.sh
./special_installs.sh
./gnome_config.sh
./choose_shell.sh
./install_megasync.sh
./mounting_folders.sh
./fstab.sh
./visudo.sh
./restore_backup.sh
./services.sh
./git_config.sh
./virtmanager.sh
./hypr_config.sh
./grub.sh
./plymouth.sh

# --- FINAL PROMPT ---
print_separator "It is recommended to restart the system"
if confirm "Do you want to restart?"; then
  sudo systemctl reboot
fi
