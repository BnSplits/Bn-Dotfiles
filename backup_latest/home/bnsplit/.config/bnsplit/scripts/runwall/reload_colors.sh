#!/bin/bash

# ------------------------------
# Variables
# ------------------------------
# Base Config Directory
CONFIG_DIR="$HOME/.config/bnsplit"
RUNWALL_DIR="$CONFIG_DIR/scripts/runwall"

# Cache Directories
CACHE_DIR="$CONFIG_DIR/cache"

# Script Paths
GTK_THEME_SCRIPT="$CONFIG_DIR/scripts/reload_gtk_theme.sh"
PAPIRUS_SCRIPT="$CONFIG_DIR/scripts/papirus_colors_name.sh"

COLOR_NUMBER=$(awk 'NR == 1' "$CONFIG_DIR/scripts/runwall/color_number")
MAIN_COL=$(awk "NR == $COLOR_NUMBER" "$CACHE_DIR/extractedColors/colors-hex")

# Generate color gradients
"$RUNWALL_DIR/col_gradient" "$MAIN_COL" "$RUNWALL_DIR/colors_gradient_templates.jsonc"

# Reload essentials
swaync-client -R
swaync-client -rs
"$GTK_THEME_SCRIPT"

# Flameshot
MID_COL=$(awk 'NR == 6' "$CONFIG_DIR/colors/colors-hex")
flameshot config --maincolor "$MID_COL"

# Optional Papirus folders
if [[ -n "$1" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
  papirus-folders -C "$("$PAPIRUS_SCRIPT")" --theme Papirus-Dark
fi

# Optional KDE Material You
if [[ -n "$2" ]]; then
  kde-material-you-colors --file "$CACHE_DIR/wallpaper" &>/dev/null
fi
