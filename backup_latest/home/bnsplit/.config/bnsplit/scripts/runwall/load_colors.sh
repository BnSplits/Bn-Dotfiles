#!/bin/bash

source "$HOME/.config/bnsplit/scripts/runwall/variables.sh"
COLOR_NUMBER=$(awk 'NR == 1' "$CONFIG_DIR/scripts/runwall/color_number")
MAIN_COL=$(awk "NR == $COLOR_NUMBER" "$CACHE_DIR/extractedColors/colors-hex")

# 1 : Generate the colors gradients to the colors folder with ./colors_gradient/colors_gradient_generator.py
python3 "$RUNWALL_DIR/colors_gradient_generator.py" "$MAIN_COL" "$RUNWALL_DIR/colors_gradient_templates.jsonc"

# 2 : Reload essentials
swaync-client -R &
swaync-client -rs &
"$GTK_THEME_SCRIPT"

# 3 : Reload optionals
if [[ -n "$1" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
  papirus-folders -C "$("$PAPIRUS_SCRIPT")" --theme Papirus-Dark &
fi

if [[ -n "$2" ]]; then
  kde-material-you-colors --file "$CACHE_DIR/wallpaper" &>/dev/null &
fi
