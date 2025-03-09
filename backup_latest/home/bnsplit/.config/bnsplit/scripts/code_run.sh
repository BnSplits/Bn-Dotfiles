#!/usr/bin/env bash

# --------------------------
# Configuration Section
# --------------------------

# List of supported languages
declare -a LANGUAGES=(
  "C"
  "JavaScript"
  "Python"
  "Bash"
  "Java"
  "Pascal"
)

# Language extensions mapping
declare -A EXTENSION_MAP=(
  ["c"]="C" ["h"]="C"
  ["js"]="JavaScript" ["mjs"]="JavaScript"
  ["py"]="Python"
  ["sh"]="Bash" ["bash"]="Bash"
  ["java"]="Java"
  ["pas"]="Pascal" ["pp"]="Pascal"
)

# --------------------------
# Operations Configuration
# --------------------------

# $FILE - Full path to the input file
# $DIR  - Directory containing the input file

declare -a OPS_C=(
  'gcc "$FILE" -o "$DIR/a.out" && "$DIR/a.out"'
  'gcc "$FILE" -o "$DIR/a.out"'
  '"$DIR/a.out"'
  'gcc -lm "$FILE" -o "$DIR/a.out" && "$DIR/a.out"'
)

declare -a OPS_JavaScript=(
  'node "$FILE"'
)

declare -a OPS_Python=(
  'python3 "$FILE"'
)

declare -a OPS_Bash=(
  'bash "$FILE"'
)

declare -a OPS_Java=(
  'javac "$FILE" && java -cp "$DIR" "$(basename "$FILE" .java)"'
)

declare -a OPS_Pascal=(
  'fpc "$FILE" -o"$DIR/a.out" && "$DIR/a.out"'
  'fpc "$FILE" -o"$DIR/a.out"'
  '"$DIR/a.out"'
)

# --------------------------
# Style Configuration
# --------------------------

# Keep existing layout and colors
FZF_BORDER="--border=rounded"
FZF_COLORS="--color=bg+:236,fg+:white,header:yellow,info:green,prompt:yellow,pointer:magenta"
FZF_LAYOUT="--height 40% --reverse"
FZF_PROMPT="❯❯❯ "

# --------------------------
# Core Functions
# --------------------------

select_language() {
  printf "%s\n" "${LANGUAGES[@]}" | fzf \
    $FZF_BORDER $FZF_COLORS $FZF_LAYOUT \
    --header="Select Language" \
    --prompt="$FZF_PROMPT"
}

select_operation() {
  local lang="$1"
  local ops_var="OPS_${lang// /_}"
  local -n ops_ref="$ops_var"

  # Add numbers to operations and preserve original commands
  local indexed_ops=()
  for ((i = 0; i < ${#ops_ref[@]}; i++)); do
    indexed_ops+=("$((i + 1)): ${ops_ref[i]}")
  done

  # Selection interface with number support
  printf "%s\n" "${indexed_ops[@]}" | fzf \
    $FZF_BORDER $FZF_COLORS $FZF_LAYOUT \
    --header="${lang} Operations" \
    --prompt="$FZF_PROMPT" \
    --bind 'start:transform-header:printf "\033[33m%s\033[0m" "Type number or search"' |
    sed -E 's/^[0-9]+: //' # Remove the numbering prefix
}

# --------------------------
# Main Execution
# --------------------------

# Confirm execution
read -p "Run script? (y/N) " confirm
[[ "$confirm" =~ [yY] ]] || exit 0

clear

# Validate file argument
if [[ $# -eq 0 || ! -f "$1" ]]; then
  echo "Error: Valid file required"
  exit 1
fi

FILE="$1"
DIR="$(dirname "$FILE")"
filename="$(basename -- "$FILE")"
extension="${filename##*.}"
[[ "$filename" == "$extension" ]] && extension=""

# Language detection
if [[ -n "$extension" && ${EXTENSION_MAP[$extension]+_} ]]; then
  lang="${EXTENSION_MAP[$extension]}"
else
  lang=$(select_language) || {
    echo "No language selected"
    exit 1
  }
fi

# Operation selection
operation=$(select_operation "$lang") || {
  echo "No operation selected"
  exit 1
}

# --------------------------
# Box Drawing Function
# --------------------------

print_box() {
  local msg="$1"
  local cols=$(tput cols)
  local border_length=$((cols - 2)) # Account for box corners

  # Remove ANSI codes for length calculation
  local clean_msg=$(echo "$msg" | sed 's/\x1b\[[0-9;]*m//g')
  local msg_length=${#clean_msg}

  # Calculate padding
  local total_space=$((cols - 2))
  local left_padding=$(((total_space - msg_length) / 2))
  local right_padding=$((total_space - msg_length - left_padding))

  # Build borders using terminal default colors
  local top_border="╔$(printf '═%.0s' $(seq 1 $border_length))╗"
  local bottom_border="╚$(printf '═%.0s' $(seq 1 $border_length))╝"

  # Print box using terminal's default color scheme
  echo -e "$top_border"
  printf "║%*s%s%*s║\n" \
    $left_padding "" \
    "$msg" \
    $right_padding ""
  echo -e "$bottom_border"
}

# Execute command
print_box "Executing: $operation"
eval "$operation"
