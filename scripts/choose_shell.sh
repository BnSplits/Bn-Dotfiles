#!/bin/bash
source ./_variables.sh

# Choose the default shell
print_separator "Default SHELL selection"
if confirm "Do you to select your default SHELL ?"; then
  read -p "$(echo -e ${YELLOW}"Choose between bash[B] / fish[F] / zsh[anything else] : "${NC})" SH
  case $SH in
  B | b)
    sudo chsh $USER -s /bin/bash
    ;;
  F | f)
    sudo chsh $USER -s /bin/fish
    ;;
  *)
    sudo chsh $USER -s /bin/zsh
    ;;
  esac
fi
