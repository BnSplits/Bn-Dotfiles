#!/bin/bash
source ./_variables.sh

# Creation of mounting points
folders=(
  "win"
  "usb1"
  "usb2"
)
print_separator "Monting folders"
if confirm "Do you want to create mounting folders in /mnt?"; then
  echo_arrow "Creation of folders..."
  for folder in "${folders[@]}"; do
    if [ ! -d "/mnt/$folder" ]; then
      echo_arrow "Creation of $folder..."
      sudo mkdir "/mnt/$folder"
      echo_arrow "Folder created !"
    fi
  done
fi
