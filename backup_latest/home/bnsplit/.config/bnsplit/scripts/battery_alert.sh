#!/bin/bash

ICON="$HOME/.icons/Papirus/24x24/status/dialog-warning.svg"
BATTERY_FILE="/sys/class/power_supply/BAT0/capacity"
STATUS_FILE="/sys/class/power_supply/BAT0/status"

NOTIFY_ID=0
NOTIFIED_25=false
TEST_MODE=false

# Check for test mode flag
if [[ "$1" == "--test" ]]; then
  TEST_MODE=true
  echo "Running in test mode"
fi

send_to_devices() {
  local message
  local connected_devices

  # Set appropriate message based on mode
  if [[ "$TEST_MODE" == "true" ]]; then
    message="[TEST] Battery check: Power profile changed"
  else
    message="Battery level is at 25% - Switching to power-saver mode"
  fi

  connected_devices=$(kdeconnect-cli -a | grep -oP '(?<=: )[a-zA-Z0-9_-]+(?= \(paired and reachable\))' 2>/dev/null)

  if [ -z "$connected_devices" ]; then
    echo "No KDE Connect devices found"
    return 1
  fi

  for device in $connected_devices; do
    echo "Sending to $device"
    kdeconnect-cli --ping-msg="$message" -d "$device"
  done
}

while true; do
  BATTERY_LEVEL=$(cat "$BATTERY_FILE")
  STATUS=$(cat "$STATUS_FILE")

  if [[ "$TEST_MODE" == "true" ]]; then
    # TEST MODE LOGIC (triggers above 25%)

    # Reset notification flag when at/below 25%
    if [[ "$BATTERY_LEVEL" -le 25 ]]; then
      NOTIFIED_25=false
    fi

    if [[ "$BATTERY_LEVEL" -gt 25 && "$NOTIFIED_25" == "false" ]]; then
      notify-send -a "System" -r "$NOTIFY_ID" "[TEST] Battery Alert" \
        "Battery ABOVE 25% (currently at ${BATTERY_LEVEL}%)" \
        -i "$ICON" --urgency=critical
      echo "[TEST] Triggering power profile change at ${BATTERY_LEVEL}%"
      # Check current profile before changing (with whitespace removal)
      current_profile=$(powerprofilesctl get | tr -d '[:space:]')
      if [[ "$current_profile" != "power-saver" ]]; then
        ~/.config/bnsplit/scripts/power_profiles.sh power-saver
      fi
      send_to_devices
      NOTIFIED_25=true
    fi
  else
    # NORMAL MODE LOGIC
    if [[ "$STATUS" != "Discharging" ]]; then
      NOTIFIED_25=false
    fi

    if [[ "$STATUS" == "Discharging" ]]; then
      # 25% notification and actions
      if [[ "$BATTERY_LEVEL" -le 25 && "$NOTIFIED_25" == "false" ]]; then
        # Check current profile before changing (with whitespace removal)
        current_profile=$(powerprofilesctl get | tr -d '[:space:]')
        if [[ "$current_profile" != "power-saver" ]]; then
          NOTIFY_ID=$(notify-send -a "System" -r "$NOTIFY_ID" "Battery Alert" \
            "Battery level at 25% - Switching to power-saver mode" \
            -i "$ICON" --urgency=critical)
          ~/.config/bnsplit/scripts/power_profiles.sh power-saver
          send_to_devices
        fi
        NOTIFIED_25=true
      fi

      # Original 20% notification
      if [[ "$BATTERY_LEVEL" -le 20 && "$BATTERY_LEVEL" -lt "$OLD_BAT" ]]; then
        NOTIFY_ID=$(notify-send -a "System" -r "$NOTIFY_ID" "Critical Battery" \
          "Battery level is at <i><b>${BATTERY_LEVEL}%</b></i>!" \
          -i "$ICON" --urgency=critical)
      fi
    fi
    OLD_BAT=$BATTERY_LEVEL
  fi

  sleep 120
done
