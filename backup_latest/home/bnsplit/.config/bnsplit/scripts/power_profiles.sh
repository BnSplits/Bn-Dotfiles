#!/bin/bash

hyprland_file="$HOME/.config/hypr/hyprland/_batterySave.conf"
current_mode=$(powerprofilesctl get)
requested_mode="$1"
wallpaper_cache="$HOME/.config/bnsplit/cache/wallpaper"
icon_path="$HOME/.icons/Papirus/64x64/apps/utilities-energy-monitor.svg"

if [[ "$requested_mode" == "$current_mode" ]]; then
  notify-send -a "System" "Power" "<b><i>$requested_mode mode is already active!</i></b>" -i "$icon_path" -t 3000
  exit 0
fi

powerprofilesctl set "$requested_mode"
case "$requested_mode" in
"power-saver")
  sed -i 's/decoration:blur:enabled = true/decoration:blur:enabled = false/' "$hyprland_file"
  sed -i 's/animations:enabled = true/animations:enabled = false/' "$hyprland_file"
  brightnessctl set 20%
  "$HOME/.config/bnsplit/scripts/inhibitor.sh" off

  if [[ "$(xdg-mime query filetype "$wallpaper_cache")" == "image/gif" ]]; then
    non_gif_walls=$(find $HOME/Pictures/Wallpapers -type f -exec file --mime-type {} + | grep -v 'image/gif' | cut -d: -f1)
    random_wall=$(echo "$non_gif_walls" | shuf -n 1)
    waypaper --wallpaper "$random_wall"
    notify-send -a "System" "Power" "<b><i>Power-saver mode activated! GIF wallpaper replaced.</i></b>" -i "$icon_path" -t 5000
  else
    notify-send -a "System" "Power" "<b><i>Power-saver mode activated!</i></b>" -i "$icon_path" -t 5000
  fi
  ;;
"balanced" | "performance")
  sed -i 's/decoration:blur:enabled = false/decoration:blur:enabled = true/' "$hyprland_file"
  sed -i 's/animations:enabled = false/animations:enabled = true/' "$hyprland_file"
  brightnessctl set 50%
  "$HOME/.config/bnsplit/scripts/inhibitor.sh" on

  if [[ -f "$wallpaper_cache.tmp" ]]; then
    mv "$wallpaper_cache.tmp" "$wallpaper_cache"
    waypaper --wallpaper "$wallpaper_cache" &
    notify-send -a "System" "Power" "<b><i>$requested_mode mode activated! Restored GIF wallpaper.</i></b>" -i "$icon_path" -t 5000
  else
    notify-send -a "System" "Power" "<b><i>$requested_mode mode activated!</i></b>" -i "$icon_path" -t 5000
  fi
  ;;
*)
  notify-send -a "System" "Power" "<b><i>Invalid power mode: $requested_mode</i></b>" -i "$icon_path" -t 3000
  exit 1
  ;;
esac
