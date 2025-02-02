#!/bin/bash

filepath="$HOME/.icons/Papirus/64x64/apps/update-notifier.svg"
temp_file="/tmp/updates_notification_count"

check_updates() {
  available_updates=$(yay -Qu | wc -l)

  if [[ -f $temp_file ]]; then
    previous_updates=$(cat $temp_file)
  else
    previous_updates=0
  fi

  if ((available_updates > 0)); then
    if ((available_updates != previous_updates)); then
      notify-send -a "Updates" "Updates Available : ( $available_updates )" "<i><b> </b></i>" -i "$filepath" -t "10000"
      echo "$available_updates" >$temp_file
    fi
  fi
}

check_updates
yay -Qu | wc -l
