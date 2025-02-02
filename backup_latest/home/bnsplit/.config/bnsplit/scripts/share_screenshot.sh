#!/bin/bash

screenshot_dir="$HOME/Pictures/Screenshots"
mkdir -p "$screenshot_dir"
filename="$(date +'%Y-%m-%d_%Hh%Mm%Ss').png"
screenshot_path="$screenshot_dir/$filename"
grim "$screenshot_path"
magick "$screenshot_path" -shave 1x1 PNG:- | wl-copy
echo "$screenshot_path"

if [[ -z "$screenshot_path" || ! -f "$screenshot_path" ]]; then
    exit 1
fi

connected_devices=$(kdeconnect-cli -a | grep -oP '(?<=: )[a-zA-Z0-9_-]+(?= \(paired and reachable\))')
for device_id in $connected_devices; do
    kdeconnect-cli --share "$screenshot_path" -d "$device_id"
done
