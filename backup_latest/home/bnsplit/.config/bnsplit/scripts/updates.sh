#!/bin/bash

ICON="$HOME/.icons/Papirus/64x64/apps/update-notifier.svg"
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

echo -ne "\n${BOLD}${YELLOW} Searching for updates... ${RESET}"
sudo yay -Sy >/dev/null 2>&1

updates_list=$(yay -Qu)
updates_count=$(echo "$updates_list" | sed '/^\s*$/d' | wc -l)

if [[ -n "$updates_list" && "$updates_count" -gt 0 ]]; then
  clear
  echo -e "${BOLD}${GREEN}✔ Updates Available: ($updates_count)${RESET}"
  echo -e "────────────────────────────────────────────────────────"
  echo "$updates_list"
  echo -e "────────────────────────────────────────────────────────"

  echo -en " ${BOLD}Do you want to start the updates? (Y/n): ${RESET}"
  read -r confirm

  if [[ $confirm == "y" || $confirm == "Y" || $confirm == "yes" || $confirm == "" ]]; then
    echo -e "\n${BOLD}${YELLOW}⏳ Starting the update...${RESET}"

    if sudo yay -Su --quiet --noconfirm; then
      echo -e "\n${BOLD}${GREEN}✔ Update completed successfully!${RESET}"
      notify-send -a "Updates" "Updates Completed" "<i><b>All updates installed successfully</b></i>" -i "$ICON" -t 10000
    else
      echo -e "\n${BOLD}${RED}✖ Update failed! Check logs for errors.${RESET}"
      notify-send -a "Updates" "Update Failed" "<i><b>An error occurred during the update</b></i>" -i "$ICON" -t 10000
    fi
  else
    echo -e "\n${BOLD}${YELLOW}⚠ Update canceled.${RESET}"
    notify-send -a "Updates" "Update Canceled" "<i><b>No updates were installed</b></i>" -i "$ICON" -t 10000
  fi
else
  echo -e "\n${BOLD}${GREEN}✔ No updates available. Your system is up to date.${RESET}"
  notify-send -a "Updates" "No Updates Available" "<i><b>Your system is already up to date</b></i>" -i "$ICON" -t 10000
fi
