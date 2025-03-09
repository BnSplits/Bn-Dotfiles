#!/bin/bash

# Find and process GNOME application files with privilege elevation only when needed
find /usr/share/applications -name 'org.gnome*.desktop' -type f -print0 | while IFS= read -r -d $'\0' file; do
  if grep -q "DBusActivatable=true" "$file"; then
    echo "Modifying: $file"
    sudo sed -i 's/DBusActivatable=true/DBusActivatable=false/g' "$file"
  fi
done
sudo update-desktop-database

echo "Operation completed"
