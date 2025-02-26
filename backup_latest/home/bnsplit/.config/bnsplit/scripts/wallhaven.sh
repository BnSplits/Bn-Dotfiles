#!/bin/bash

# Default settings
API_URL="https://wallhaven.cc/api/v1/search"
TARGET_DIR="$HOME/Pictures/Wallhaven"
MAX_IMAGES=50
ICON_PATH="$HOME/.icons/Papirus/32x32/apps/image-viewer.svg"

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Mappings for categories and purity
declare -A categories_map=(
  ["general"]="100"
  ["anime"]="010"
  ["people"]="001"
)

declare -A purity_map=(
  ["sfw"]="100"
  ["sketchy"]="010"
  ["nsfw"]="001"
)

show_help() {
  cat <<EOF
Wallhaven Downloader Script

Usage: $0 [PARAMETERS]

Parameters (key=value format):
  API Parameters:
  categories=    (general|anime|people) or 3-digit binary code
                 Each digit represents: general|anime|people
                 Example: 110 = general+anime, 101 = general+people
  purity=        (sfw|sketchy|nsfw) or 3-digit binary code
                 Each digit represents: sfw|sketchy|nsfw
                 Example: 110 = sfw+sketchy, 101 = sfw+nsfw
  sorting=       (date_added|relevance|random|views|favorites|toplist)
  order=         (desc|asc)
  topRange=      (1d|3d|1w|1M|3M|6M|1y) - Requires sorting=toplist
  atleast=       Minimum resolution (e.g. 1920x1080)
  resolutions=   Exact resolution (e.g. 1920x1080,1920x1200)
  ratios=        Aspect ratio (e.g. 16x9,16x10,landscape,portrait,landscape%2Cportrait)
  colors=        Hex color filter (e.g. 336600,cc0000)
  page=          Pagination number (e.g. 1-12,42-69)

  File Management:
  output=        Custom output directory (default: ~/Pictures/Wallhaven)
  max=           Max total wallpapers to keep (default: $MAX_IMAGES)

  Misc:
  apikey=        API key for NSFW content

Examples:
  $0 categories=anime purity=sfw max=30
  $0 sorting=random ratios=16x9
  $0 help         # Show this help message

Notes:
- Parameters can be in any order
- Duplicate files are automatically skipped
- Oldest files deleted when exceeding max limit
EOF
}

# Parse command line arguments
params=()
for arg in "$@"; do
  # Handle help first
  [[ "$arg" == "help" || "$arg" == "--help" ]] && {
    show_help
    exit 0
  }

  key="${arg%%=*}"
  value="${arg#*=}"

  # Handle output directory
  if [[ "$key" == "output" ]]; then
    TARGET_DIR="$value"
    continue # Skip adding to API params
  fi

  # Handle max parameter
  if [[ "$key" == "max" ]]; then
    MAX_IMAGES="$value"
    continue
  fi

  # Handle categories and purity mappings
  case "$key" in
  categories)
    # Handle binary codes or named categories
    if [[ "$value" =~ ^[01]{3}$ ]]; then
      : # Use direct binary code
    elif [[ -n "${categories_map[$value]:-}" ]]; then
      value="${categories_map[$value]}"
    else
      echo "Invalid categories value: $value"
      echo "Valid values: general, anime, people, or 3-digit binary code"
      exit 1
    fi
    ;;
  purity)
    if [[ "$value" =~ ^[01]{3}$ ]]; then
      : # Use direct binary code
    elif [[ -n "${purity_map[$value]:-}" ]]; then
      value="${purity_map[$value]}"
    else
      echo "Invalid purity value: $value"
      echo "Valid values: sfw, sketchy, nsfw, or 3-digit binary code"
      exit 1
    fi
    ;;
  esac

  params+=("${key}=${value}")
done

# Add per_page parameter if not specified
per_page_exists=false
for param in "${params[@]}"; do
  if [[ "$param" == per_page=* ]]; then
    per_page_exists=true
    break
  fi
done

if ! $per_page_exists; then
  params+=("per_page=$MAX_IMAGES")
fi

# Build API URL
if [ ${#params[@]} -gt 0 ]; then
  IFS='&' eval 'query_params="${params[*]}"'
  API_URL="$API_URL?$query_params"
fi

# Fetch image URLs
image_urls=$(curl -s "$API_URL" | jq -r ".data[0:$MAX_IMAGES][].path")

# Download images
downloaded=0
for url in $image_urls; do
  filename=$(basename "$url")
  if [ ! -f "$TARGET_DIR/$filename" ]; then
    echo "Downloading $filename..."
    if curl -s -o "$TARGET_DIR/$filename" "$url"; then
      ((downloaded++))
    else
      rm -f "$TARGET_DIR/$filename"
    fi
  fi
done

# Check and delete oldest files if exceeding MAX_IMAGES
current_count=$(find "$TARGET_DIR" -maxdepth 1 -type f | wc -l)
deleted=0
if [ $current_count -gt $MAX_IMAGES ]; then
  to_delete=$((current_count - MAX_IMAGES))
  # Find oldest files and delete them
  find "$TARGET_DIR" -maxdepth 1 -type f -printf '%T@ %p\0' |
    sort -z -n |
    cut -z -d' ' -f2- |
    head -z -n "$to_delete" |
    xargs -0 rm -f
  deleted=$to_delete
fi

# Send notification
if [ $downloaded -gt 0 ] || [ $deleted -gt 0 ]; then
  notify-send -a "Wallpaper Updates" "Wallpaper Update" \
    "New wallpapers added: $downloaded\nOld wallpapers deleted: $deleted\nLocation: $TARGET_DIR" \
    -i "$ICON_PATH" \
    -t 10000
fi
