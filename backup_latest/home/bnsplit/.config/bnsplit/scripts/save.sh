#!/bin/bash

# Clear the screen
clear

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
#!/bin/bash

# Clear the screen
clear

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display messages with arrows
function echo_arrow() { echo -e "${BLUE}=> $1${NC}"; }
function echo_success() { echo -e "${GREEN}\u2713 $1${NC}"; }
function echo_warning() { echo -e "${YELLOW}\u26A0 $1${NC}"; }
function echo_error() { echo -e "${RED}\u2717 $1${NC}\n"; }
function print_separator() {
  echo -e "\n${CYAN}##############################${NC}"
  echo -e "${CYAN}# $1${NC}"
  echo -e "${CYAN}##############################${NC}\n"
}

# Function to write to log file
function log_message() {
  echo "$1" >>"$LOG_FILE"
}

# Directories and variables
BACKUPS_DIR="$HOME/Dotfiles/backups"
LOG_FILE="$HOME/Dotfiles/backup_log.txt"
MEGA_DIR="$HOME/MEGA"
DATE=$(date "+%Y-%b-%d_%H-%M-%S")
CURRENT_BACKUP_DIR="$BACKUPS_DIR/$DATE"
LATEST_BACKUP_DIR="$HOME/Dotfiles/backup_latest"
LATEST_ARCHIVE="$HOME/Dotfiles/backup_$DATE.tar.gz"

# Items to backup
items_to_backup=(
  "$HOME/.cache/blured-square-600-x50y50/"
  "$HOME/.cache/blured-walls/"
  "$HOME/.cache/wall-png/"
  "$HOME/.config/ags"
  "$HOME/.config/bnsplit"
  "$HOME/.config/cava"
  "$HOME/.config/fastfetch"
  "$HOME/.config/flameshot/"
  "$HOME/.config/ghostty"
  "$HOME/.config/gtk-3.0"
  "$HOME/.config/gtk-4.0"
  "$HOME/.config/hypr"
  "$HOME/.config/kdeconnect"
  "$HOME/.config/kitty"
  "$HOME/.config/matugen"
  "$HOME/.config/nvim"
  "$HOME/.config/qt6ct"
  "$HOME/.config/rofi"
  "$HOME/.config/spicetify"
  "$HOME/.config/swaync"
  "$HOME/.config/sys64"
  "$HOME/.config/waybar"
  "$HOME/.config/waypaper"
  "$HOME/.config/yay"
  "$HOME/.config/yazi"
  "$HOME/.config/"*.bak
  "$HOME/.fonts"
  "$HOME/.local/share/gvfs-metadata/"
  "$HOME/.local/share/data/Mega Limited"
  "$HOME/.local/share/gnome-shell/extensions"
  "$HOME/.local/share/nvim/mason"
  "$HOME/.local/share/keyrings"
  "$HOME/.themes/custom-adw"
  "$HOME/.tmux"
  "$HOME/.zen"

  "/etc/makepkg.conf"
  "/etc/ly/config.ini"
  "$HOME/.config/chrome-flags.conf"
  "$HOME/.config/code-flags.conf"
  "$HOME/.config/mimeapps.list"
  "$HOME/.config/starship.toml"
  "$HOME/.bashrc"
  "$HOME/.tmux.conf"
  "$HOME/.Xresources"
  "$HOME/.zshrc"
)

# Function to create directory with error checking
function create_backup_dir() {
  if [[ ! -d "$1" ]]; then
    mkdir -p "$1" || {
      echo_error "Failed to create $1"
      exit 1
    }
  fi
}

# Core functions
setup_directories() {
  mkdir -p "$BACKUPS_DIR" "$MEGA_DIR"
}

delete_old_backups() {
  print_separator "Checking Existing Backups"
  existing_backups=$(ls -1 "$BACKUPS_DIR" | wc -l)
  MAX_BACKUPS=$((3))

  if [ "$existing_backups" -ge "$MAX_BACKUPS" ]; then
    oldest_backup=$(ls -1t "$BACKUPS_DIR" | tail -n 1)
    echo_arrow "Deleting oldest backup: $oldest_backup"
    rm -rf "$BACKUPS_DIR/$oldest_backup" || {
      echo_error "Failed to delete $oldest_backup"
      exit 1
    }
  fi
}

save_gnome_settings() {
  print_separator "Saving GNOME Settings"
  GNOME_SETTINGS_FILE="$HOME/Dotfiles/gnome-settings-backup.dconf"
  echo_arrow "Exporting GNOME settings to $GNOME_SETTINGS_FILE..."
  if dconf dump / >"$GNOME_SETTINGS_FILE"; then
    echo_success "GNOME settings successfully saved to $GNOME_SETTINGS_FILE"
    log_message "GNOME settings saved to $GNOME_SETTINGS_FILE"
  else
    echo_error "Failed to export GNOME settings"
    log_message "Error: Failed to save GNOME settings"
    exit 1
  fi
}

save_libvirt_vms() {
  print_separator "Saving libvirt VMs"
  echo_arrow "Saving libvirt VMs using libvirt_vms.sh..."
  "$HOME/.config/bnsplit/scripts/libvirt_vms.sh" dump
}

prepare_backup_directories() {
  create_backup_dir "$BACKUPS_DIR"
  create_backup_dir "$CURRENT_BACKUP_DIR"
}

backup_items() {
  print_separator "Backing Up Files and Folders"
  log_message "Backup started at $(date)"
  saved_items=()

  for item in "${items_to_backup[@]}"; do
    if [ -e "$item" ]; then
      dest="$CURRENT_BACKUP_DIR/$item"
      dest_dir=$(dirname "$dest")
      create_backup_dir "$dest_dir"

      if [ -d "$item" ]; then
        echo_arrow "Copying directory $item..."
        cp -rT "$item" "$dest" || {
          echo_error "Error copying directory $item"
          exit 1
        }
      else
        echo_arrow "Copying file $item..."
        cp "$item" "$dest" || {
          echo_error "Error copying file $item"
          exit 1
        }
      fi
      saved_items+=("$item")
    else
      echo_warning "$item does not exist, skipping backup"
    fi
  done
}

update_latest_backup() {
  print_separator "Updating Latest Backup"
  echo_arrow "Removing old latest backup directory..."
  rm -rf "$LATEST_BACKUP_DIR" 2>/dev/null

  echo_arrow "Creating new latest backup directory..."
  mkdir -p "$LATEST_BACKUP_DIR" || {
    echo_error "Failed to create latest backup directory"
    exit 1
  }

  echo_arrow "Syncing current backup to latest..."
  cp -r "$CURRENT_BACKUP_DIR/"* "$LATEST_BACKUP_DIR" || {
    echo_error "Failed to update latest backup"
    exit 1
  }
  echo_success "Latest backup directory updated"
}

refresh_sddm_themes() {
  print_separator "Refreshing SDDM Themes"
  echo_arrow "Updating SDDM themes in Dotfiles..."
  sudo rm -rf "${HOME}/Dotfiles/sddm-themes/"* &&
    cp -r "/usr/share/sddm/themes/"* "${HOME}/Dotfiles/sddm-themes/" || {
    echo_error "Failed to refresh SDDM themes"
    exit 1
  }
  echo_success "SDDM themes updated successfully"
}

compress_backup() {
  print_separator "Creating Final Archive"
  echo_arrow "Compressing latest backup..."
  tar -czf "$LATEST_ARCHIVE" -C "$LATEST_BACKUP_DIR" . || {
    echo_error "Failed to create compressed archive"
    exit 1
  }
  echo_success "Backup compressed to: $LATEST_ARCHIVE"
}

# Main execution flow
setup_directories
delete_old_backups
# save_gnome_settings
save_libvirt_vms
prepare_backup_directories
backup_items
update_latest_backup
refresh_sddm_themes
# compress_backup

# Final status
echo -e "${CYAN}\n-------------------------------------------------------------------------------"
echo_success "Backup process completed at $(date)"
