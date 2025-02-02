#!/bin/bash

# Path to GRUB themes
themes_dir="/boot/grub/themes"

# Check if the directory exists
if [[ ! -d "$themes_dir" ]]; then
    echo "The directory $themes_dir does not exist."
    exit 1
fi

# Iterate through all subdirectories
find "$themes_dir" -mindepth 2 -maxdepth 2 -type d | while read -r subdir; do
    echo "Processing the directory: $subdir"

    # Delete the install.sh file if it exists
    install_file="$subdir/install.sh"
    if [[ -f "$install_file" ]]; then
        echo "Deleting $install_file"
        rm "$install_file"
    fi

    # Find the only sub-subdirectory
    sub_subdirs=("$subdir"/*/)
    if [[ ${#sub_subdirs[@]} -eq 1 ]]; then
        sub_subdir="${sub_subdirs[0]}"
        echo "Moving the contents of $sub_subdir to $subdir"

        # Move the contents
        mv "$sub_subdir"* "$subdir"

        # Delete the empty sub-subdirectory
        echo "Deleting the empty directory $sub_subdir"
        rmdir "$sub_subdir"
    else
        echo "None or multiple sub-subdirectories found in $subdir, skipped."
    fi
done

echo "Processing complete."
