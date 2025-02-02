#!/bin/bash

iconpath="$HOME/.icons/Papirus/32x32/status/dialog-information.svg"
filepath="$HOME/.config/hypr/hyprland/_xray-windows.conf"

header() {
  echo "# ========================================
#               XRAY WINDOWS
# ========================================
"
}

active_opacity=0.85
inactive_opacity=0.78

last_line=$(tail -n 1 "$filepath")

if [[ "$last_line" =~ ^windowrule\ =\ opacity\ 0\.85,\ \.\*$ ]]; then
  header >$filepath
  notify-send -a "System" "Xray deactivated for all windows!" "<i><b> </b></i>" -i "$iconpath" -t "5000"
else
  header >$filepath
  echo "windowrule = opacity 0.85, .*" >>$filepath
  notify-send -a "System" "Xray activated for all windows!" "<i><b> </b></i>" -i "$iconpath" -t "5000"
fi
