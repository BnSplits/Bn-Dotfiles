#!/bin/bash
source ./_variables.sh

# --- PLYMOUTH SETUP FUNCTION ---
print_separator "Plymouth Boot Animation Setup"
if confirm "Do you want to install and configure Plymouth?"; then
  # Installation Section
  if pacman -Q plymouth &>/dev/null; then
    echo_success "plymouth is already installed"
  else
    echo_arrow "Installing plymouth..."
    if yay -S --noconfirm --quiet plymouth; then
      echo_success "plymouth installed"
    else
      echo_error "plymouth not installed"
    fi
  fi

  # Ask user if they want to edit configuration files
  if confirm "Do you want to edit configuration files?"; then
    EDIT_CONFIG=true
  else
    EDIT_CONFIG=false
  fi

  # Initramfs Configuration
  if [ "$EDIT_CONFIG" = true ]; then
    echo " "
    echo_arrow "Configuring initramfs hooks"
    echo_warning "We need to add ${CYAN}plymouth${YELLOW} to the HOOKS array in:"
    echo -e "${BLUE}/etc/mkinitcpio.conf${NC}"
    echo -e "Required modification: ${CYAN}HOOKS=(base udev plymouth autodetect ...)${NC}"
    read -p "$(echo -e "${BLUE}=> Press any key to edit configuration file...${NC}")" -n1 -s
    echo
    sudo $EDITOR /etc/mkinitcpio.conf
    sudo mkinitcpio -p linux
    echo_success "Initramfs hooks updated"
  fi

  # GRUB Configuration
  if [ "$EDIT_CONFIG" = true ]; then
    echo " "
    echo_arrow "Configuring GRUB parameters"
    echo_warning "Add these parameters to ${CYAN}GRUB_CMDLINE_LINUX_DEFAULT${YELLOW}:"
    echo -e "${CYAN}splash rd.udev.log_priority=3 vt.global_cursor_default=0${NC}"
    echo -e "In file: ${BLUE}/etc/default/grub${NC}"
    read -p "$(echo -e "${BLUE}=> Press any key to edit GRUB configuration...${NC}")" -n1 -s
    echo
    sudo $EDITOR /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    echo_success "GRUB configuration updated"
  fi

  # Theme Installation
  echo " "
  echo_arrow "Installing custom themes"
  theme_source="../plymouth-themes"
  if [[ -d "$theme_source" ]]; then
    sudo cp -r "$theme_source"/* /usr/share/plymouth/themes/
    echo_success "Theme files successfully installed to: ${CYAN}/usr/share/plymouth/themes/${GREEN}"
  else
    echo_error "Theme source directory not found: ${CYAN}$theme_source${RED}"
    echo_error "Please ensure Plymouth theme files are placed in: ${CYAN}$theme_source${RED}"
    echo_error "Download pre-made themes from: ${CYAN}https://github.com/adi1090x/plymouth-themes${RED}"
  fi

  # Theme Selection
  echo " "
  echo_arrow "Select your Plymouth theme"
  PL_THEME=$(ls /usr/share/plymouth/themes/ | fzf --height=40% --border --ansi \
    --prompt="Choose theme > " --header="Use arrow keys | Enter to select")

  if [[ -n "$PL_THEME" ]]; then
    sudo plymouth-set-default-theme -R "$PL_THEME"
    echo_success "Active theme set to: ${GREEN}$PL_THEME"
  else
    echo_warning "No theme selected - keeping current configuration"
  fi

  echo_success "Plymouth configuration complete!"
fi
