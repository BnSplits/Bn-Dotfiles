#!/bin/bash
source ./_variables.sh

print_separator "Installation of Virtmanager KVM/QEMU"
if confirm "Do you want to install and configure Virtmanager with KVM/QEMU?"; then
  read -p "Do you want to start? " s
  echo "START KVM/QEMU/VIRT MANAGER INSTALLATION..."

  # ------------------------------------------------------
  # Install Packages
  # ------------------------------------------------------
  sudo pacman -Sy virt-manager virt-viewer qemu-base qemu-desktop vde2 ebtables iptables-nft nftables dnsmasq bridge-utils ovmf swtpm

  # ------------------------------------------------------
  # Edit libvirtd.conf
  # ------------------------------------------------------
  echo "Manual steps required:"
  echo "Open sudo vim /etc/libvirt/libvirtd.conf:"
  echo 'Remove # at the following lines: unix_sock_group = "libvirt" and unix_sock_rw_perms = "0770"'
  read -p "Press any key to open libvirtd.conf: " c
  sudo vim /etc/libvirt/libvirtd.conf
  # sudo echo 'log_filters="3:qemu 1:libvirt"' >>/etc/libvirt/libvirtd.conf
  echo 'log_filters="3:qemu 1:libvirt"' | sudo tee -a /etc/libvirt/libvirtd.conf
  # sudo echo 'log_outputs="2:file:/var/log/libvirt/libvirtd.log"' >>/etc/libvirt/libvirtd.conf
  echo 'log_outputs="2:file:/var/log/libvirt/libvirtd.log"' | sudo tee -a /etc/libvirt/libvirtd.conf

  # ------------------------------------------------------
  # Add user to the group
  # ------------------------------------------------------
  sudo usermod -a -G kvm,libvirt $(whoami)

  # ------------------------------------------------------
  # Enable services
  # ------------------------------------------------------
  sudo systemctl enable libvirtd
  sudo systemctl start libvirtd

  # ------------------------------------------------------
  # Edit qemu.conf
  # ------------------------------------------------------
  echo "Manual steps required:"
  echo "Open sudo vim /etc/libvirt/qemu.conf"
  echo "Uncomment and add your user name to user and group."
  echo 'user = "your username"'
  echo 'group = "your username"'
  read -p "Press any key to open qemu.conf: " c
  sudo vim /etc/libvirt/qemu.conf

  # ------------------------------------------------------
  # Restart Services
  # ------------------------------------------------------
  sudo systemctl restart libvirtd

  # ------------------------------------------------------
  # Autostart Network
  # ------------------------------------------------------
  sudo virsh net-autostart default
fi
