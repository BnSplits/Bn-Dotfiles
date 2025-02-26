#!/usr/bin/env bash

CACHE_DIR="$HOME/.cache/daily"
CACHE_FILE="$CACHE_DIR/last_date"

# Define your commands array
CMDS=(
  "$HOME/.config/bnsplit/scripts/wallhaven.sh categories=110 purity=110 max=16 ratios=landscape sorting=toplist topRange=1d"
)

mkdir -p "$CACHE_DIR"

while true; do
  current_date=$(date +%F)
  last_date=$(cat "$CACHE_FILE" 2>/dev/null || echo "unset")

  if [[ "$last_date" != "$current_date" ]]; then
    echo "New day detected. Running daily commands..."

    for cmd in "${CMDS[@]}"; do
      echo "Executing: $cmd"
      eval "$cmd"
    done

    echo "$current_date" >"$CACHE_FILE"
    echo "Daily commands completed"
  fi

  sleep 3600
done
