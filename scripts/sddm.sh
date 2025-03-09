#!/usr/bin/env bash
source ./_variables.sh

print_separator "SDDM setup"
if confirm "Do you want to setup SDDM?"; then
  echo ""
  echo_arrow "Select your SDDM theme"
  sddm_themes_dir="$(realpath "$(dirname "$0")/../sddm-themes")"

  SDDM_THEME=$(ls "$sddm_themes_dir" | fzf --height=40% --border --ansi \
    --prompt="Choose theme > " --header="Use arrow keys | Enter to select") || {
    echo_warning "Theme selection cancelled"
    exit 1
  }

  if [[ -n "$SDDM_THEME" ]]; then
    sudo mkdir -p /usr/share/sddm/themes
    sudo cp -r "${sddm_themes_dir}/${SDDM_THEME}" /usr/share/sddm/themes/ || {
      echo_error "Failed to copy SDDM theme"
      exit 1
    }

    sudo mkdir -p /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=${SDDM_THEME}" | sudo tee /etc/sddm.conf.d/theme.conf >/dev/null

    echo_success "Active theme set to: ${GREEN}${SDDM_THEME}"
    sudo systemctl enable sddm

    # Add X11 touchpad configuration for SDDM
    echo_arrow "Configuring X11 touchpad settings for SDDM..."
    sudo mkdir -p /etc/X11/xorg.conf.d

    sudo tee /etc/X11/xorg.conf.d/30-touchpad.conf >/dev/null <<EOF
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "TappingButtonMap" "lrm"
    Option "NaturalScrolling" "false"
EndSection
EOF

    if [[ $? -ne 0 ]]; then
      echo_error "Failed to configure touchpad settings"
      exit 1
    fi

    echo_success "Touchpad settings configured for tap-to-click"
  else
    echo_warning "No theme selected - keeping current configuration"
  fi

  icon_source_dir="$(realpath "$(dirname "$0")/../Bibata-Modern-Classic")"
  if [[ -d "$icon_source_dir" ]]; then
    sudo cp -r "$icon_source_dir" "/usr/share/icons/" || {
      echo_error "Failed to copy icon theme"
      exit 1
    }
    echo "[Icon Theme]
Inherits=Bibata-Modern-Classic" | sudo tee /usr/share/icons/default/index.theme >/dev/null
  else
    echo_warning "Icon theme directory not found at ${icon_source_dir}"
  fi
fi

if confirm "Do you want to set the avatar icon?"; then
  avatar_source="$(realpath "$(dirname "$0")/../avatar")"

  if [[ ! -f "$avatar_source" ]]; then
    echo_error "Avatar file not found at ${avatar_source}"
    exit 1
  fi

  target_icon="/var/lib/AccountsService/icons/${USER}"
  sudo mkdir -p "/var/lib/AccountsService/icons"
  if sudo cp "$avatar_source" "$target_icon"; then
    echo_success "New avatar set${GREEN}"

    if systemctl is-active accounts-daemon &>/dev/null; then
      sudo systemctl restart accounts-daemon
      echo_success "Accounts service restarted"
    else
      echo_warning "Accounts-daemon not running - changes might not take effect immediately"
    fi
  else
    echo_error "Failed to copy avatar (check permissions/file existence)"
    exit 1
  fi
fi
