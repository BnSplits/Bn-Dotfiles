#!/bin/bash

# Define cache directory and files
CACHE_DIR="$HOME/.config/bnsplit/cache"
CACHE_FILE="$CACHE_DIR/spot-art-url"
LOGO_FILE="$HOME/Pictures/Logos/logo2.png"
SPOT_ART="$CACHE_DIR/spot-art"
SPOT_ART_BLUR="$CACHE_DIR/spot-art-blur"

# Ensure cache directory exists
mkdir -p "$CACHE_DIR"

last_url=""

# Init the art image
cp "$LOGO_FILE" "$SPOT_ART"

# Continuously monitor Spotify metadata for album art URL
playerctl --follow -p spotify metadata mpris:artUrl | while read -r new_url; do
  # If spot-art doesn't exist OR the URL is invalid (does not start with http)
  if [[ ! -f "$SPOT_ART" || ! "$new_url" =~ ^http ]]; then
    cp "$LOGO_FILE" "$SPOT_ART"
    rm -f "$SPOT_ART_BLUR"
    echo "Invalid or no album art, using default logo."
    last_url=""
    continue
  fi

  # Avoid redundant downloads if the URL hasn't changed
  if [[ "$new_url" != "$last_url" ]]; then
    last_url="$new_url"

    # Attempt to download the new album art
    if curl -fsS "$new_url" -o "$SPOT_ART"; then
      # Apply blur effect to the downloaded image
      magick "$SPOT_ART" -blur 0x12 "$SPOT_ART_BLUR"
      echo "$new_url" >"$CACHE_FILE"
      echo "Album art updated."
    else
      # If download fails, revert to the default logo
      cp "$LOGO_FILE" "$SPOT_ART"
      rm -f "$SPOT_ART_BLUR"
      echo "Download failed, using default logo."
    fi
  fi
done
