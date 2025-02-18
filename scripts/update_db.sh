#!/bin/bash
source ./_variables.sh

# Update package database
print_separator "Updating package database"
if confirm "Do you want to update the package database?"; then
  sudo pacman -Sy --quiet || {
    echo_error "Failed to update package database"
    exit 1
  }
fi
