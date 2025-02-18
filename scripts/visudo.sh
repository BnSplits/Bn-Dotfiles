#!/bin/bash
source ./_variables.sh

# Edit sudoers
print_separator "Visudo"
if confirm "Do you want to edit your sudoers file?"; then
  echo -e "${CYAN}You will edit your sudoers file !"
  echo -e "${CYAN}Add a line like this : 'bnsplit ALL=(ALL) NOPASSWD: <the command that you wnant ot grant permissions>'"
  echo -ne "${CYAN}Press any key to start.."
  read c
  sudo visudo
fi
