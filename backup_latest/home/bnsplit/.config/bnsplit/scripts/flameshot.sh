#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
OBSIDIAN_DIR="$HOME/Obsidian/99 Assets"
mkdir -p "$SCREENSHOT_DIR" "$OBSIDIAN_DIR"

timestamp="$(date +'%Y-%m-%d_%Hh%Mm%Ss')"
FILE_NAME="${timestamp}.png"

swaync-client --dnd-on

take_screenshot() {
  local mode="$1"
  local path="$2"

  XDG_CURRENT_DESKTOP=sway
  flameshot "$mode" --path "$path" -c

  local exit_status=$?
  swaync-client --dnd-off

  if [ $exit_status -eq 0 ]; then
    notify-send -a "Screenshot" "Screenshot Taken" "<i>Saved and copied to clipboard</i>\n<b>$path</b>" -i "$path" -t 5000
  else
    notify-send -a "Screenshot" "Screenshot Aborted" "The screenshot capture was cancelled." -t 5000
  fi
}

case "$1" in
"record-obs")
  obs --startrecording --minimize-to-tray &
  ;;
"part")
  take_screenshot "gui" "$SCREENSHOT_DIR/$FILE_NAME"
  ;;
"full")
  take_screenshot "full" "$SCREENSHOT_DIR/$FILE_NAME"
  ;;
"obsidian")
  take_screenshot "gui" "$OBSIDIAN_DIR/$FILE_NAME"
  ;;
"kdeconnect")
  take_screenshot "gui" "$SCREENSHOT_DIR/$FILE_NAME"
  connected_devices=$(kdeconnect-cli -a | grep -oP '(?<=: )[a-zA-Z0-9_-]+(?= \(paired and reachable\))')

  if [[ -z "$connected_devices" ]]; then
    echo "No connected KDE Connect devices found" >&2
    exit 1
  fi

  for device in $connected_devices; do
    kdeconnect-cli --share "$SCREENSHOT_DIR/$FILE_NAME" -d "$device"
  done
  ;;
*)
  echo "Invalid command: $1" >&2
  echo "Available commands: record-obs, part, full, obsidian, kdeconnect"
  exit 1
  ;;
esac

exit 0
