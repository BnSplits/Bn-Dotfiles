#!/bin/bash
source ./_variables.sh

# --- POWER BUTTON ---
print_separator "Power Button"
if confirm "Change power button action to do nothing?"; then
  echo "Press Enter to edit /etc/systemd/logind.conf"
  echo "Edit this line: #HandlePowerKey=poweroff → HandlePowerKey=ignore"
  read _
  sudo vim /etc/systemd/logind.conf
fi
