#!/bin/bash
DUMP_FOLDER="$HOME/.config/bnsplit/libvirt-vms"

# Check if exactly one argument is provided.
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 [dump|define]"
  exit 1
fi

# Create the dump folder if it doesn't exist
if [ ! -d "$DUMP_FOLDER" ]; then
  mkdir -p "$DUMP_FOLDER" || {
    echo "Failed to create directory: $DUMP_FOLDER"
    exit 1
  }
fi

# Determine action based on the argument.
case "$1" in
dump)
  echo "Cleaning old XMLs saved in '$DUMP_FOLDER'..."
  rm "$DUMP_FOLDER"/*
  echo "Dumping configurations for all VMs..."
  for vm in $(sudo virsh list --all --name); do
    echo "Dumping configuration for VM: $vm"
    sudo virsh dumpxml "$vm" >"$DUMP_FOLDER/${vm}.xml"
  done
  ;;
define)
  echo "Defining VMs from XML files..."
  for xml in "$DUMP_FOLDER"/*.xml; do
    [ -e "$xml" ] || continue
    echo "Defining VM from file: $xml"
    sudo virsh define "$xml"
  done
  ;;
*)
  echo "Invalid argument: $1"
  echo "Usage: $0 [dump|define]"
  exit 1
  ;;
esac
