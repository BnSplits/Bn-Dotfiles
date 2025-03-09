#!/usr/bin/env bash

CACHE_DIR="$HOME/.cache/daily"
CACHE_FILE="$CACHE_DIR/last_date"

# Define your commands array
CMDS=(
  "zsh -i -c wallhaven > /dev/null"
)

TIME_SLEEP=600

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

  sleep "$TIME_SLEEP"
done
