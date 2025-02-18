#!/bin/bash
source ./_variables.sh

# Manual fstab editing
print_separator "Manual fstab editing"
if confirm "Do you want to manually edit your /etc/fstab file?"; then
  sudo vim /etc/fstab
fi
