#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Directories for saving screenshots
screenshot_dir="$HOME/Pictures/Screenshots"
obsidian_dir="$HOME/Obsidian/99 Assets"

mkdir -p "$screenshot_dir" "$obsidian_dir"

# Generate a timestamp-based filename
timestamp="$(date +'%Y-%m-%d_%Hh%Mm%Ss')"
filename="${timestamp}.png"

# Function: Send a desktop notification
send_notification() {
  local message="$1"
  local icon="$2"
  notify-send -a "Screenshot" "Screenshot" "$message" -i "$icon" -t 5000
}

# Function: Copy image to clipboard using magick and wl-copy
copy_to_clipboard() {
  local image_file="$1"
  if magick "$image_file" PNG:- | wl-copy; then
    send_notification "<i>Saved and copied to clipboard:<b> $image_file</b></i>" "$image_file"
  else
    send_notification "Failed to copy to clipboard" ""
  fi
}

# Function: Capture a region (using slurp to select area)
capture_region() {
  local target="$1"
  if grim -g "$(slurp)" "$target"; then
    copy_to_clipboard "$target"
  else
    send_notification "Capture stopped or failed" ""
    exit 1
  fi
}

# Function: Capture a full screen
capture_full() {
  local target="$1"
  if grim "$target"; then
    copy_to_clipboard "$target"
  else
    send_notification "Capture stopped or failed" ""
    exit 1
  fi
}

# Function: Capture for KDE Connect
capture_kdeconnect() {
  local target_dir="$HOME/Pictures/Screenshots"
  mkdir -p "$target_dir"
  local ts
  ts="$(date +'%Y-%m-%d_%Hh%Mm%Ss')"
  local target="${target_dir}/${ts}.png"

  if grim "$target"; then
    if magick "$target" -shave 1x1 PNG:- | wl-copy; then
      send_notification "<i>Saved and copied to clipboard:<b> $target</b></i>" "$target"
    else
      send_notification "Failed to copy to clipboard" ""
    fi
  else
    send_notification "Capture stopped or failed" ""
    exit 1
  fi

  if [[ ! -f "$target" ]]; then
    echo "File not found: $target" >&2
    exit 1
  fi

  # Share the screenshot to all connected KDE Connect devices
  local connected_devices
  connected_devices=$(kdeconnect-cli -a | grep -oP '(?<=: )[a-zA-Z0-9_-]+(?= \(paired and reachable\))')
  for device in $connected_devices; do
    kdeconnect-cli --share "$target" -d "$device"
  done

  echo "$target"
}

# Main: Choose capture mode based on the first argument
case "${1:-}" in
part)
  filepath="${screenshot_dir}/${filename}"
  capture_region "$filepath"
  echo "$filepath"
  ;;
obsidian)
  filepath="${obsidian_dir}/${filename}"
  capture_region "$filepath"
  echo "$filepath"
  ;;
full)
  filepath="${screenshot_dir}/${filename}"
  capture_full "$filepath"
  echo "$filepath"
  ;;
kdeconnect)
  capture_kdeconnect
  ;;
*)
  echo "Usage: $0 {part|obsidian|full|kdeconnect}"
  exit 1
  ;;
esac
