#!/bin/bash

if [[ "$1" == "exit" ]]; then
  echo ":: Exit"
  sleep 0.5
  killall -9 Hyprland
  sleep 2
fi

if [[ "$1" == "lock" ]]; then
  echo ":: Lock"
  sleep 0.5
  hyprlock
fi

if [[ "$1" == "reboot" ]]; then
  echo ":: Reboot"
  sleep 0.5
  systemctl reboot
  sleep 2
fi

if [[ "$1" == "shutdown" ]]; then
  echo ":: Shutdown"
  sleep 0.5
  systemctl poweroff
  sleep 2
fi

if [[ "$1" == "suspend" ]]; then
  echo ":: Suspend"
  hyprlock &
  sleep 0.5
  systemctl suspend
  sleep 2
fi

if [[ "$1" == "hibernate" ]]; then
  echo ":: Hibernate"
  sleep 1
  systemctl hibernate
fi
