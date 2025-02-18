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

# --- DEPENDENCY CHECKS ---
if ! command -v yay &>/dev/null; then
  echo_error "yay is not installed. Install yay before continuing."
  exit 1
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
