#!/bin/bash

source "$HOME/.config/bnsplit/scripts/runwall/variables.sh"
WALL="$1"

# ------------------------------
# Image Processing
# ------------------------------
file_type=$(file --mime-type -b "$WALL")
WALL_HASH=$(sha256sum "$WALL" | awk '{print $1}')

process_image() {
  local img="$1"

  # PNG version
  if [[ ! -f "$WALL_PNG_DIR/$WALL_HASH" ]]; then
    magick "$img" -strip -resize 1920x1080^ -gravity center -extent 1920x1080 \
      PNG32:"$CACHE_WALLPAPER_PNG"
    cp "$CACHE_WALLPAPER_PNG" "$WALL_PNG_DIR/$WALL_HASH"
  else
    cp "$WALL_PNG_DIR/$WALL_HASH" "$CACHE_WALLPAPER_PNG"
  fi

  if [[ -n "$2" ]]; then

    # Blurred version
    if [[ ! -f "$BLUR_DIR/$WALL_HASH" ]]; then
      magick "$img" -strip -resize 1920x1080^ -gravity center -extent 1920x1080 \
        -blur 0x25 "$CACHE_WALLPAPER_BLUR"
      cp "$CACHE_WALLPAPER_BLUR" "$BLUR_DIR/$WALL_HASH"
    else
      cp "$BLUR_DIR/$WALL_HASH" "$CACHE_WALLPAPER_BLUR"
    fi

    # Square crop version
    if [[ ! -f "$BLUR_SQUARE_600_X50Y50_DIR/$WALL_HASH" ]]; then
      magick "$CACHE_WALLPAPER_BLUR" \
        -gravity northwest -crop 600x600+50+50 +repage \
        -fill "rgba(0,0,0,0.3)" -draw "rectangle 0,0 600,600" \
        PNG32:"$CACHE_WALLPAPER_BLUR_PNG_SQUARE_600_X50Y50"
      cp "$CACHE_WALLPAPER_BLUR_PNG_SQUARE_600_X50Y50" "$BLUR_SQUARE_600_X50Y50_DIR/$WALL_HASH"
    else
      cp "$BLUR_SQUARE_600_X50Y50_DIR/$WALL_HASH" "$CACHE_WALLPAPER_BLUR_PNG_SQUARE_600_X50Y50"
    fi
  fi
}

if [[ "$file_type" == "image/gif" ]]; then
  process_image "${CACHE_WALLPAPER}[0]" &
else
  process_image "$CACHE_WALLPAPER" &
fi

wait
exit 0
