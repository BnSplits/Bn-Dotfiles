#!/bin/bash

# Load variables
source "$HOME/.config/bnsplit/scripts/runwall/variables.sh"

# Ensure a wallpaper argument is provided
if [[ -z "$1" ]]; then
  echo "Error: No wallpaper specified."
  exit 1
fi

WALL="$1"

# 1: Cache the wallpaper
"$CONFIG_DIR/scripts/runwall/wall_caching.sh" "$WALL"

# 2: Extract colors from the wallpaper
python3 "$RUNWALL_DIR/wall_to_colors.py" "$WALL"

# 3: Reload apps that need to be updated with new colors
# Usage: "$CONFIG_DIR/scripts/runwall/load_colors.sh" <arg1> <arg2>
# - If <arg1> is set, updates Papirus folder colors.
# - If <arg2> is set, applies KDE Material You colors.
"$CONFIG_DIR/scripts/runwall/load_colors.sh" p

# 4: Process the wallpaper (apply blur and other effects if needed)
# Usage: "$CONFIG_DIR/scripts/runwall/wall_proc.sh" "$WALL" <arg2>
# - If <arg2> is set, applies a blur effect and performs additional processing on the wallpaper.
"$CONFIG_DIR/scripts/runwall/wall_proc.sh" "$WALL"

# Ensure all background processes finish before exiting
wait
exit 0
