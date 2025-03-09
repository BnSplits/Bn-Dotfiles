#!/bin/bash

COLOR=$(hyprpicker -a)

# Create an image with the selected color and save as PNG
magick -size 64x64 xc:"$COLOR" "/tmp/${COLOR}.png"

# Send notification with the generated image as an icon
notify-send "Color Picked" "$COLOR" -i "/tmp/${COLOR}.png"
