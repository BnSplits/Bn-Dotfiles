#!/bin/bash

sudo echo -n
yay -Sy
updates_list=$(yay -Qu)
updates_count=$(echo "$updates_list" | wc -l)
clear
echo "Searching for updates..."
if [ $( echo "$updates_list" | wc -c) != 0 ]; then
  clear
  echo "---------------------------------------------------------------------------------"
  echo "$updates_list"
  echo "---------------------------------------------------------------------------------"
  read -r -p "Do you want to start $updates_count the updates? (Y/n) : " confirm
  if [[ $confirm == "y" || $confirm == "Y" || $confirm == "yes" || $confirm == "" ]]; then
    echo "Starting the update..."
    yay -Su --quiet --noconfirm
  else
    echo "Update canceled."
  fi
else
  exit 0
fi
