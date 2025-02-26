#!/bin/bash
source ./_variables.sh

print_separator "Fabric"

if confirm "Do you want to install and configure Fabric?"; then
  yay -S python-fabric-git
fi
