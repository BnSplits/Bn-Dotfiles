#!/bin/bash
source ./_variables.sh

print_separator "HP Printer"
# HP printer setup
if confirm "Do you want to configure a printer with hp-setup -i?"; then
  sudo systemctl enable --now cups && sudo systemctl start cups && hp-setup -i || echo_error "Printer setup failed"
fi

print_separator "Bluetooth"
# Bluetooth setup
if confirm "Do you want to configure Bluetooth?"; then
  sudo systemctl enable --now bluetooth.service
  sudo systemctl start bluetooth.service
fi

# Docker Configuration
print_separator "Configuring Docker"
if confirm "Do you want to configure Docker?"; then
  echo_arrow "Enabling Docker service..."
  sudo systemctl enable --now docker &&
    echo_success "Docker service enabled and started" &&
    echo_arrow "adding user to docker group" &&
    sudo usermod -aG docker $USER &&
    echo_success "user added"
fi
