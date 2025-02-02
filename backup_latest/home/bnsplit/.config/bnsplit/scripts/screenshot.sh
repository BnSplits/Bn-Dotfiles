#!/bin/bash

screenshot_dir="$HOME/Pictures/Screenshots"

mkdir -p "$screenshot_dir"

filename="$(date +'%Y-%m-%d_%Hh%Mm%Ss').png"

filepath="$screenshot_dir/$filename"

if [ "$1" == "part" ]; then
  grim -g "$(slurp)" "$filepath"
elif [ "$1" == "full" ]; then
  grim "$filepath"
else
  echo "Invalid option. Use 'part' for partial capture or 'full' for full screen."
  exit 1
fi

if [ $? -eq 0 ]; then
  magick "$filepath" -shave 1x1 PNG:- | wl-copy

  if [ $? -eq 0 ]; then
    notify-send -a "Screenshot" "Screenshot" "<i>Saved and copied to clipboard :<b>  $filepath</b></i>" -i "$filepath" -t "5000"
  else
    notify-send -a "Screenshot" "Screenshot" "Failed to copy to clipboard" -t "5000"
  fi
else
  notify-send -a "Screenshot" "Screenshot" "Capture stopped or failed" -t "5000"
fi

echo "$filepath"
