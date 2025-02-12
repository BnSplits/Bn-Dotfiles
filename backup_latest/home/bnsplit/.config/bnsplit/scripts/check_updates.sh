#!/bin/bash

ICON_PATH="$HOME/.icons/Papirus/64x64/apps/update-notifier.svg"
TEMP_FILE="/tmp/updates_notification_count"

check_updates() {
  sudo yay -Sy
  available_updates=$(yay -Qu | wc -l)

  if [[ -f $TEMP_FILE ]]; then
    previous_updates=$(cat "$TEMP_FILE")
  else
    previous_updates=0
  fi

  if ((available_updates > 0)) && ((available_updates != previous_updates)); then
    notify-send -a "Updates" "Updates Available : ($available_updates)" "<i><b>New updates are available.</b></i>" -i "$ICON_PATH" -t 10000
    echo "$available_updates" >"$TEMP_FILE"
  fi
}

check_updates
