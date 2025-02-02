#!/bin/bash

filepath="$HOME/.config/hypr/hyprland/_maximized-windows.conf"

header() {
  echo "# ========================================
#            MAXIMIZED WINDOWS
# ========================================
"
}

if [[ $(hyprctl getoption general:gaps_out | grep 0) ]]; then
  header >$filepath
  echo "general {
    gaps_in = 4
    gaps_out = 5
    border_size = 2
}
decoration {
    rounding = 5
}
" >>$filepath
else
  header >$filepath
  echo "general {
    gaps_in = 0
    gaps_out = 0
    border_size = 1
}
decoration {
    rounding = 0
}
" >>$filepath
fi
