#!/bin/bash
source ./_variables.sh

# Grub customizing
print_separator "Grub Theming"
if confirm "Do you want to apply a theme to grub?"; then
  echo -e "${BLUE}=> Enter a screen resolution supported by Grub (e.g., 1920x1080): ${NC}"
  echo -e "${YELLOW}⚠ Ensure the resolution is supported by Grub by running 'videoinfo' in Grub! (default : 1920x1080)${NC}"
  read -r SCREEN_RES
  SCREEN_RES=${SCREEN_RES:-1920x1080}

  echo -e "${BLUE}=> Press a key to select a theme... ${NC}"
  read -n 1

  if [[ ! -d "/boot/grub/themes/" ]]; then
    sudo mkdir -p /boot/grub/themes/
  fi

  SELECTED_FOLDER=$(ls $HOME/Dotfiles/grub-themes | fzf --height=40% --border --ansi)
  SELECTED_THEME=$(ls $HOME/Dotfiles/grub-themes/"$SELECTED_FOLDER"/ | fzf --height=40% --border --ansi)

  sudo rm -rf /boot/grub/themes/*
  sudo cp -r $HOME/Dotfiles/grub-themes/"$SELECTED_FOLDER"/ /boot/grub/themes/"$SELECTED_FOLDER"/

  sudo sed -i '/^GRUB_BACKGROUND/s/^/#/' /etc/default/grub
  sudo sed -i "s/^GRUB_GFXMODE=.*/GRUB_GFXMODE=$SCREEN_RES/" /etc/default/grub
  sudo sed -i '/^#\?GRUB_THEME/c\GRUB_THEME="/boot/grub/themes/'"$SELECTED_FOLDER/$SELECTED_THEME/theme.txt"'"' /etc/default/grub

  sudo grub-mkconfig -o /boot/grub/grub.cfg
fi
