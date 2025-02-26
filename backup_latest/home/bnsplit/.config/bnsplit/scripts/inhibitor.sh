#!/bin/bash

iconpath="$HOME/.icons/Papirus/64x64/apps/sleep.svg"

case "$#" in
0)
  # Toggle the state
  if pgrep -x "hypridle" >/dev/null; then
    pkill -x "hypridle"
    notify-send -a "System" "Inhibitor ON ! " "<i><b> </b></i>" -i "$iconpath" -t 5000
  else
    hypridle &
    notify-send -a "System" "Inhibitor OFF ! " "<i><b> </b></i>" -i "$iconpath" -t 5000
  fi
  ;;
1)
  case "$1" in
  on)
    pkill -x "hypridle"
    notify-send -a "System" "Inhibitor ON ! " "<i><b> </b></i>" -i "$iconpath" -t 5000
    ;;
  off)
    if ! pgrep -x "hypridle" >/dev/null; then
      hypridle &
    fi
    notify-send -a "System" "Inhibitor OFF ! " "<i><b> </b></i>" -i "$iconpath" -t 5000
    ;;
  *)
    echo "Error: Invalid argument. Use 'on', 'off', or no argument to toggle."
    exit 1
    ;;
  esac
  ;;
*)
  echo "Error: Too many arguments. Usage: $0 [on|off]"
  exit 1
  ;;
esac
