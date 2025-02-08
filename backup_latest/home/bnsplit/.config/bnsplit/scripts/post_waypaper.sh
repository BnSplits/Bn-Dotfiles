#!/bin/bash
set -euo pipefail

# Redirect all script output (stdout & stderr) to Zenity progress dialog
# exec > >(zenity --progress --no-cancel --auto-close --pulsate --text " " --title "   Colorscheme application ..." --percentage=0) 2>&1

# ------------------------------
# Configuration
# ------------------------------
CONFIG_DIR="$HOME/.config/bnsplit"
ZEN_TABLISS_WAL="$HOME/.zen/cy6bohdq.Default (alpha)/storage/default/moz-extension+++23533115-4010-4a65-8652-8b7871386a09^userContextId=4294967295/idb/3647222921wleabcEoxlt-eengsairo.files"
PAPIRUS_SCRIPT="$CONFIG_DIR/scripts/colors_name.sh"
GTK_THEME_SCRIPT="$CONFIG_DIR/scripts/reload_gtk_theme.sh"

CACHE_DIR="$CONFIG_DIR/cache"
CACHE_WALLPAPER="$CACHE_DIR/wallpaper"
CACHE_WALLPAPER_PNG="$CACHE_DIR/wallpaper-png"
CACHE_WALLPAPER_BLUR="$CACHE_DIR/wallpaper-blur"
CACHE_WALLPAPER_BLUR_PNG_SQUARE_600_X50Y50="$CACHE_DIR/wallpaper-blur-square-png-600-x50y50"

# Directories to cache processed wallpapers based on file hash
BLUR_DIR="$HOME/.cache/blured-walls"
WALL_PNG_DIR="$HOME/.cache/wall-png"
BLUR_SQUARE_600_X50Y50_DIR="$HOME/.cache/blured-square-600-x50y50"
PAPIRUS_FOLDERS="$HOME/.local/bin/papirus-folders"

# ------------------------------
# Input Validation
# ------------------------------
if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <path_to_image>"
  exit 1
fi

input_image="$1"

# ------------------------------
# Pre-create Necessary Directories
# ------------------------------
mkdir -p "$(dirname "$CACHE_WALLPAPER")" \
  "$(dirname "$CACHE_WALLPAPER_PNG")" \
  "$(dirname "$CACHE_WALLPAPER_BLUR_PNG_SQUARE_600_X50Y50")" \
  "$ZEN_TABLISS_WAL" \
  "$BLUR_SQUARE_600_X50Y50_DIR" \
  "$BLUR_DIR" \
  "$WALL_PNG_DIR"

# ------------------------------
# Copy Original Image to Cache Locations (in parallel)
# ------------------------------
cp "$input_image" "$CACHE_WALLPAPER" &
# cp "$input_image" "$ZEN_TABLISS_WAL/1" &
wait

# ------------------------------
# Launch Independent Tasks in Parallel (non-blocking)
# ------------------------------
# Generate colors (fire-and-forget)
(matugen -v image "$input_image")
# Reload system notifications
(swaync-client -R) &
(swaync-client -rs) &
# Reload GTK theme
("$GTK_THEME_SCRIPT") &

# ------------------------------
# Determine MIME Type and File Hash (for caching)
# ------------------------------
file_type=$(file --mime-type -b "$input_image")
WALL_HASH=$(sha256sum "$input_image" | awk '{print $1}')

# ------------------------------
# Function: Process and Cache Image Conversions
# ------------------------------
process_image() {
  local img="$1" # "$CACHE_WALLPAPER" or "$CACHE_WALLPAPER[0]" for GIFs

  # # ----------------------------
  # # Combined PNG Wallpaper and Blurred Wallpaper Generation
  # # ----------------------------
  # if [[ -f "$WALL_PNG_DIR/$WALL_HASH" && -f "$BLUR_DIR/$WALL_HASH" ]]; then
  #   cp "$WALL_PNG_DIR/$WALL_HASH" "$CACHE_WALLPAPER_PNG"
  #   cp "$BLUR_DIR/$WALL_HASH" "$CACHE_WALLPAPER_BLUR"
  # else
  #   # Generate a 1920x1080, metadata-stripped PNG and a blurred version in one command.
  #   magick "$img" -strip -resize 1920x1080^ -gravity center -extent 1920x1080 \
  #     \( +clone -write mpr:png +delete \) \
  #     \( mpr:png -blur 0x25 -write "$CACHE_WALLPAPER_BLUR" +delete \) \
  #     PNG32:"$CACHE_WALLPAPER_PNG"
  #   cp "$CACHE_WALLPAPER_PNG" "$WALL_PNG_DIR/$WALL_HASH"
  #   cp "$CACHE_WALLPAPER_BLUR" "$BLUR_DIR/$WALL_HASH"
  # fi

  # ----------------------------
  # Blurred Wallpaper Generation
  # ----------------------------
  if [[ -f "$BLUR_DIR/$WALL_HASH" ]]; then
    cp "$BLUR_DIR/$WALL_HASH" "$CACHE_WALLPAPER_BLUR"
  else
    # Generate a 1920x1080 blurred version in one command.
    magick "$img" -strip -resize 1920x1080^ -gravity center -extent 1920x1080 \
      -blur 0x25 "$CACHE_WALLPAPER_BLUR"
    cp "$CACHE_WALLPAPER_BLUR" "$BLUR_DIR/$WALL_HASH"
  fi

  # ----------------------------
  # PNG Wallpaper Generation
  # ----------------------------
  if [[ -f "$WALL_PNG_DIR/$WALL_HASH" ]]; then
    cp "$WALL_PNG_DIR/$WALL_HASH" "$CACHE_WALLPAPER_PNG"
  else
    # Generate a 1920x1080, metadata-stripped PNG in one command.
    magick "$img" -strip -resize 1920x1080^ -gravity center -extent 1920x1080 \
      PNG32:"$CACHE_WALLPAPER_PNG"
    cp "$CACHE_WALLPAPER_PNG" "$WALL_PNG_DIR/$WALL_HASH"
  fi

  # ----------------------------
  # Process Blurred Square Crop (600x600 at offset 50,50)
  # ----------------------------
  if [[ -f "$BLUR_SQUARE_600_X50Y50_DIR/$WALL_HASH" ]]; then
    cp "$BLUR_SQUARE_600_X50Y50_DIR/$WALL_HASH" "$CACHE_WALLPAPER_BLUR_PNG_SQUARE_600_X50Y50"
  else
    magick "$CACHE_WALLPAPER_BLUR" \
      -gravity northwest -crop 600x600+50+50 +repage \
      -fill "rgba(0,0,0,0.3)" -draw "rectangle 0,0 600,600" \
      PNG32:"$CACHE_WALLPAPER_BLUR_PNG_SQUARE_600_X50Y50"
    cp "$CACHE_WALLPAPER_BLUR_PNG_SQUARE_600_X50Y50" "$BLUR_SQUARE_600_X50Y50_DIR/$WALL_HASH"
  fi
}

# ------------------------------
# Process Image Based on MIME Type
# ------------------------------
# For GIFs, process only the first frame (using the [0] suffix understood by ImageMagick)
if [[ "$file_type" == "image/gif" ]]; then
  process_image "${CACHE_WALLPAPER}[0]" &
else
  process_image "$CACHE_WALLPAPER" &
fi

# ------------------------------
# kde-material-you-colors
# ------------------------------
kde-material-you-colors --file ~/.config/bnsplit/cache/current-wallpaper &

# ------------------------------
# Update Papirus Folder Colors (in parallel)
# ------------------------------
# wait
(
  color_value=$("$PAPIRUS_SCRIPT")
  "$PAPIRUS_FOLDERS" -C "$color_value" --theme Papirus-Dark
) &
#
# ------------------------------
# Wait for All Background Tasks to Finish
# ------------------------------
wait
exit 0
