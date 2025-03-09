#!/bin/bash

# Save original terminal settings
original_stty=$(stty -g)

# Set terminal to raw mode and disable echo
stty raw -echo -icanon

input=""
echo -n "> " # Initial prompt

while true; do
  # Read one character at a time
  char=$(dd bs=1 count=1 2>/dev/null)

  # Handle Enter key (clear input)
  if [[ "$char" == $'\r' ]]; then
    input=""
    echo -ne "\r> "
    continue
  fi

  # Handle backspace/delete
  if [[ "$char" == $'\x7f' || "$char" == $'\x08' ]]; then
    input="${input%?}"
    echo -ne "\b \b"
  else
    input+="$char"
    echo -n "$char"
  fi

  # Move to new line, run qalc, then re-display prompt
  echo -ne "\n"
  qalc "$input"
  echo -ne "\r> "
done

# Restore original terminal settings
stty "$original_stty"
