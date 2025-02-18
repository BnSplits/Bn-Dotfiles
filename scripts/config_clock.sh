#!/bin/bash
source ./_variables.sh

# Configure clock for dual boot with Windows
print_separator "Configuring internal clock for dual boot with Windows"
if confirm "Do you want to configure the internal clock for dual boot with Windows?"; then
  timedatectl set-local-rtc 1 --adjust-system-clock
fi
