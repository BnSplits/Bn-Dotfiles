#!/bin/bash

# Files and scripts
colors_file="$HOME/.config/bnsplit/colors/colors-source"

# Check if the file exists
if [[ ! -f "$colors_file" ]]; then
  echo "Error: The file $colors_file does not exist."
  exit 1
fi

# Définition des couleurs Papirus
declare -A papirus_colors=(
    [black]="#000000"
    [blue]="#2196f3"
    [bluegrey]="#607d8b"
    [breeze]="#87ceeb"
    [brown]="#795548"
    [carmine]="#960018"
    [cyan]="#00bcd4"
    [darkcyan]="#008b8b"
    [deeporange]="#ff5722"
    [green]="#4caf50"
    [grey]="#9e9e9e"
    [indigo]="#3f51b5"
    [magenta]="#ff00ff"
    [nordic]="#5e81ac"
    [orange]="#ff9800"
    [palebrown]="#d7ccc8"
    [paleorange]="#ffe0b2"
    [pink]="#e91e63"
    [red]="#f44336"
    [teal]="#009688"
    [violet]="#9c27b0"
    [white]="#ffffff"
    [yellow]="#ffeb3b"
)

hex_to_rgb() {
    local hex="$1"
    hex="${hex#'#'}"
    echo "$((16#${hex:0:2})) $((16#${hex:2:2})) $((16#${hex:4:2}))"
}

color_distance() {
    local r1=$1 g1=$2 b1=$3 r2=$4 g2=$5 b2=$6
    echo "sqrt(($r1 - $r2)^2 + ($g1 - $g2)^2 + ($b1 - $b2)^2)" | bc -l
}

find_nearest_color() {
    local input_hex="$1"
    read -r r1 g1 b1 <<< "$(hex_to_rgb "$input_hex")"
    local min_distance=999999
    local nearest_color=""

    for color_name in "${!papirus_colors[@]}"; do
        read -r r2 g2 b2 <<< "$(hex_to_rgb "${papirus_colors[$color_name]}")"
        distance=$(color_distance $r1 $g1 $b1 $r2 $g2 $b2)
        if (( $(echo "$distance < $min_distance" | bc -l) )); then
            min_distance=$distance
            nearest_color=$color_name
        fi
    done
    echo "$nearest_color"
}

# Dictionary to count occurrences of each color name
declare -A color_count

# Read each line from the colors file
while IFS= read -r color; do
  if [[ -n "$color" ]]; then
    # Get the color name directly using the Bash function
    color_name=$(find_nearest_color "$color")

    # Check if the output is not empty
    if [[ -n "$color_name" ]]; then
      # Increment the counter for this color name
      ((color_count["$color_name"]++))
    fi
  fi
done <"$colors_file"

# Find the most frequent color name
most_frequent_color=""
max_count=0

for name in "${!color_count[@]}"; do
  if ((color_count["$name"] > max_count)); then
    most_frequent_color="$name"
    max_count=${color_count["$name"]}
  fi
done

if [[ -n "$most_frequent_color" ]]; then
  echo "$most_frequent_color"
else
  echo "blue"
fi
