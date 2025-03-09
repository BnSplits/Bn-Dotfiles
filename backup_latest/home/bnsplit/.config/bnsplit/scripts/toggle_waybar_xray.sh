#!/bin/bash

FILE="$HOME/.config/waybar/style.css"

# Find first occurrence of either background variable
first_match=$(grep -m 1 -E "background: @[sx]-background;" "$FILE" 2>/dev/null)

case "$first_match" in
*@s-background*)
  sed -i '0,/background: @s-background;/s//background: @x-background;/' "$FILE"
  ;;
*@x-background*)
  sed -i '0,/background: @x-background;/s//background: @s-background;/' "$FILE"
  ;;
*)
  echo "No valid background variable found in $FILE"
  exit 1
  ;;
esac
