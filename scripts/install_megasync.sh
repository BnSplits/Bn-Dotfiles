#!/bin/bash
source ./_variables.sh

# Install Megasync
print_separator "Installing Megasync"
if confirm "Do you want to install Megasync?"; then
  megasync_pkg="megasync-x86_64.pkg.tar.zst"
  megasync_url="https://mega.nz/linux/repo/Arch_Extra/x86_64/$megasync_pkg"
  cd $HOME/Downloads

  if [ ! -f "$megasync_pkg" ]; then
    echo_arrow "Downloading Megasync..."
    wget "$megasync_url" || {
      echo_error "Failed to download Megasync"
      exit 1
    }
  fi

  echo_arrow "Installing Megasync..."
  sudo pacman -U "$megasync_pkg" --noconfirm || echo_error "Failed to install Megasync"
  rm -f "$megasync_pkg"
fi
