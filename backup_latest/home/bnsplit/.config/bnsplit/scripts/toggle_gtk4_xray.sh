#!/bin/bash

file="$HOME/.themes/custom-adw/gtk-4.0/colors.css"

if [[ ! -f $file ]]; then
  exit 1
fi

if grep -q "xray" "$file"; then
  echo "'xray' to 'solid'..."
  sed -i 's/xray/solid/g' "$file"
elif grep -q "solid" "$file"; then
  echo "'solid' to 'xray'..."
  sed -i 's/solid/xray/g' "$file"
else
  echo "No 'xray' or 'solid' in $file."
fi

$HOME/.config/bnsplit/scripts/reload_gtk_theme.sh
