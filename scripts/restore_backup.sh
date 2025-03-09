#!/bin/bash
source ./_variables.sh

# Backup archive restoration
ARCHIVE_BACKUP="../backup_latest/"

if [ -d "$ARCHIVE_BACKUP" ]; then
  print_separator "Restoring backup"
  if confirm "Do you want to restore the backup?"; then
    echo_arrow "Replacing files and folders..."
    for file in "$ARCHIVE_BACKUP/$HOME/."*; do
      file_name=$(basename "$file")
      dest_file="$HOME/$file_name"

      # Check if the file is a broken symbolic link
      if [ -L "$dest_file" ] && [ ! -e "$dest_file" ]; then
        echo_warning "$dest_file is a broken symlink, deleting..."
        rm "$dest_file"
      fi

      if [ -f "$file" ] || [ -d "$file" ]; then
        echo_arrow "Copying $file_name to $HOME/"
        cp -r "$file" "$HOME/"
        echo_success "$file_name copied to $HOME/"
      fi
    done

    for file in "$ARCHIVE_BACKUP/etc/"*; do
      file_name=$(basename "$file")
      if [ -f "$file" ] || [ -d "$file_name" ]; then
        echo_arrow "Copying $file to /etc"
        sudo cp "$file" "/etc"
        echo_success "$file_name copied to /etc"
      fi
    done

    for file in "$ARCHIVE_BACKUP/boot/"*; do
      if [ -f "$file" ] || [ -d "$file" ]; then
        echo_arrow "Copying $file to /boot"
        sudo cp -r "$file" "/boot"
        echo_success "$file copied to /boot"
      fi
    done
    echo_success "Restoration complete"
  fi
else
  echo_warning "No backup archive folder found. Proceeding to the next step."
fi

if confirm "Do you want to restore your libvirt Virtual Machines?"; then
  "$HOME/.config/bnsplit/scripts/libvirt_vms.sh" define
fi
