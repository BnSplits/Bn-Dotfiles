#!/bin/bash

hyprland_file="$HOME/.config/hypr/hyprland/batterySave.conf"

wallpaper_type=$(xdg-mime query filetype $HOME/.config/bnsplit/cache/wallpaper)

current_profile=$(powerprofilesctl get | tr -d '[:space:]')

if [[ "$current_profile" = "power-saver" ]]; then
  powerprofilesctl set balanced

  sed -i 's/decoration:blur:enabled = false/decoration:blur:enabled = true/' "$hyprland_file"
  echo "Toggled to true"

  brightnessctl set 50%

  # Restore the previous animated (GIF) wallpaper if it exists
  if [[ -f $HOME/.config/bnsplit/cache/wallpaper.tmp ]]; then
    mv $HOME/.config/bnsplit/cache/wallpaper.tmp $HOME/.config/bnsplit/cache/wallpaper
    waypaper --wallpaper $HOME/.config/bnsplit/cache/wallpaper &
    notify-send -a "System" "Power" "<b><i>Save mode deactivated! \nPrevious GIF wallpaper applied!</i></b>" -i "$HOME/.icons/Papirus/64x64/apps/utilities-energy-monitor.svg" -t "5000"
  else
    # Notify just that save mode is deactivated
    notify-send -a "System" "Power" "<b><i>Save mode deactivated!</i></b>" -i "$HOME/.icons/Papirus/64x64/apps/utilities-energy-monitor.svg" -t "5000"
  fi

elif [[ "$current_profile" = "balanced" || "$current_profile" = "performance" ]]; then
  powerprofilesctl set power-saver

  sed -i 's/decoration:blur:enabled = true/decoration:blur:enabled = false/' "$hyprland_file"
  echo "Toggled to false"
  
  brightnessctl set 20%

  # Replace GIF wallpaper if the current one is a GIF
  if [ "$wallpaper_type" = 'image/gif' ]; then
    notify-send -a "System" "Power" "<b><i>Save mode activated! \nGIF wallpaper replaced by a non GIF one!</i></b>" -i "$HOME/.icons/Papirus/64x64/apps/utilities-energy-monitor.svg" -t "5000"

    non_gif_walls=$(find $HOME/Pictures/Wallpapers -type f -exec file --mime-type {} + | grep -v 'image/gif' | cut -d: -f1)
    random_wall=$(echo "${non_gif_walls[@]}" | tr ' ' '\n' | shuf -n 1)
    waypaper --wallpaper "$random_wall"
    wait

    hypridle &
  else
    # Notify save mode activation without replacing the wallpaper
    hypridle &
    notify-send -a "System" "Power" "<b><i>Save mode activated!</i></b>" -i "$HOME/.icons/Papirus/64x64/apps/utilities-energy-monitor.svg" -t "5000"
  fi
fi
