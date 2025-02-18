#!/bin/bash

# ------------------------------
# Variables (previously in variables.sh)
# ------------------------------
CONFIG_DIR="$HOME/.config/bnsplit"
RUNWALL_DIR="$CONFIG_DIR/scripts/runwall"

CACHE_DIR="$CONFIG_DIR/cache"
CACHE_WALLPAPER="$CACHE_DIR/wallpaper"
CACHE_WALLPAPER_PNG="$CACHE_DIR/wallpaper-png"
CACHE_WALLPAPER_BLUR="$CACHE_DIR/wallpaper-blur"
CACHE_WALLPAPER_BLUR_PNG_SQUARE_600_X50Y50="$CACHE_DIR/wallpaper-blur-square-png-600-x50y50"

BLUR_DIR="$HOME/.cache/blured-walls"
WALL_PNG_DIR="$HOME/.cache/wall-png"
BLUR_SQUARE_600_X50Y50_DIR="$HOME/.cache/blured-square-600-x50y50"

ZEN_TABLISS_WAL="$HOME/.zen/cy6bohdq.Default (alpha)/storage/default/moz-extension+++e6c79793-47e0-4a4f-a4ca-a9ee6c771d63^userContextId=4294967295/idb/3647222921wleabcEoxlt-eengsairo.files"
COLOR_SOURCE="$CONFIG_DIR/colors/colors-source"

GTK_THEME_SCRIPT="$CONFIG_DIR/scripts/reload_gtk_theme.sh"
PAPIRUS_SCRIPT="$RUNWALL_DIR/papirus_colors_name.sh"

# ------------------------------
# Functions
# ------------------------------

load_colors() {
  COLOR_NUMBER=$(awk 'NR == 1' "$CONFIG_DIR/scripts/runwall/color_number")
  MAIN_COL=$(awk "NR == $COLOR_NUMBER" "$CACHE_DIR/extractedColors/colors-hex")

  # Generate color gradients
  "$RUNWALL_DIR/col_gradient" "$MAIN_COL" "$RUNWALL_DIR/colors_gradient_templates.jsonc"

  # Reload essentials
  swaync-client -R
  swaync-client -rs
  "$GTK_THEME_SCRIPT"

  # Optional Papirus folders
  if [[ -n "$1" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
    papirus-folders -C "$("$PAPIRUS_SCRIPT")" --theme Papirus-Dark
  fi

  # Optional KDE Material You
  if [[ -n "$2" ]]; then
    kde-material-you-colors --file "$CACHE_DIR/wallpaper" &>/dev/null
  fi
}

wall_proc() {
  local WALL="$1"
  local file_type=$(file --mime-type -b "$WALL")
  local WALL_HASH=$(sha256sum "$WALL" | awk '{print $1}')

  process_image() {
    local input_file="$1"

    # PNG version
    if [[ ! -f "$WALL_PNG_DIR/$WALL_HASH" ]]; then
      magick "$input_file" -strip -resize 1920x1080^ -gravity center -extent 1920x1080 \
        PNG32:"$CACHE_WALLPAPER_PNG"
      cp "$CACHE_WALLPAPER_PNG" "$WALL_PNG_DIR/$WALL_HASH"
    else
      cp "$WALL_PNG_DIR/$WALL_HASH" "$CACHE_WALLPAPER_PNG"
    fi
  }

  # Start processing
  if [[ "$file_type" == "image/gif" ]]; then
    process_image "${WALL}[0]" &
  else
    process_image "$WALL" &
  fi
}

# ------------------------------
# Main Execution
# ------------------------------
[[ -z "$1" ]] && echo "Error: No wallpaper specified." && exit 1

WALL="$1"

# 1. Cache wallpaper
cp "$WALL" "$CACHE_WALLPAPER" &
cp "$WALL" "$ZEN_TABLISS_WAL/1" &

# 2. Extract colors
"$RUNWALL_DIR/col_gen" "$WALL"

# 3. Reload colors and apps
load_colors "Papirus" & # Pass "Papirus" as $1, KDE slot $2 remains empty

# 4. Process wallpaper
wall_proc "$WALL"

wait # Ensure background processes complete before exiting
