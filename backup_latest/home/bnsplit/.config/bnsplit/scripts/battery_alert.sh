#!/bin/bash

ICON="$HOME/.icons/Papirus/24x24/status/dialog-warning.svg"
BATTERY_FILE="/sys/class/power_supply/BAT0/capacity"
STATUS_FILE="/sys/class/power_supply/BAT0/status"

OLD_BAT=$(cat "$BATTERY_FILE")
NOTIFY_ID=0

while true; do
  BATTERY_LEVEL=$(cat "$BATTERY_FILE")
  STATUS=$(cat "$STATUS_FILE")

  if [[ "$STATUS" == "Discharging" && "$BATTERY_LEVEL" -le 20 && "$BATTERY_LEVEL" -lt "$OLD_BAT" ]]; then
    NOTIFY_ID=$(notify-send -a "System" -r "$NOTIFY_ID" "Alert" "Battery level is at <i><b>${BATTERY_LEVEL}%</b></i>!" -i "$ICON" --urgency=critical)
  fi

  OLD_BAT=$BATTERY_LEVEL
  sleep 120
done
