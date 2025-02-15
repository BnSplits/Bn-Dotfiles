#!/usr/bin/env bash
set -euo pipefail

# Wrapper for notifications
notify() {
  local title="$1"
  local message="$2"
  local icon="$3"
  local timeout="${4:-5000}"
  notify-send -a "System" "$title" "$message" -i "$icon" -t "$timeout"
}

# Toggle the "xray" opacity rule for Hyprland windows
toggle_all_xray() {
  local iconpath="$HOME/.icons/Papirus/32x32/status/dialog-information.svg"
  local filepath="$HOME/.config/hypr/hyprland/_xray-windows.conf"
  local header="# ========================================
#               XRAY WINDOWS
# ========================================
"

  # Create the config file with a header if it doesn't exist
  if [[ ! -f "$filepath" ]]; then
    echo "$header" >"$filepath"
  fi

  # Check the last line for the active opacity rule
  local last_line
  last_line=$(tail -n 1 "$filepath")

  if [[ "$last_line" =~ ^windowrule\ =\ opacity\ 0\.9,\ \.\*$ ]]; then
  # if [[ $(grep opacity $HOME/.config/hypr/hyprland/_xray-windows.conf) ]]; then
    # Rule is active; remove it by writing only the header
    echo "$header" >"$filepath"
    notify "Xray deactivated for all windows!" "<i><b> </b></i>" "$iconpath"
  else
    # Rule is inactive; activate it by appending the rule
    echo "$header" >"$filepath"
    echo -e "windowrule = opacity 0.9, .*" >>"$filepath"
    # echo -e "decoration:active_opacity = 0.92\ndecoration:inactive_opacity = 0.8" >>"$filepath"
    notify "Xray activated for all windows!" "<i><b> </b></i>" "$iconpath"
  fi
}

# Toggle the GTK theme setting between "xray" and "solid" for the specified GTK version
toggle_gtk_theme() {
  local gtk_version="$1"
  local file="$HOME/.themes/custom-adw/gtk-${gtk_version}.0/colors.css"
  local reload_script="$HOME/.config/bnsplit/scripts/reload_gtk_theme.sh"
  local iconpath="$HOME/.icons/Papirus/32x32/status/dialog-information.svg"

  if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found." >&2
    return 1
  fi

  local new_state
  if grep -q "xray" "$file"; then
    echo "Switching from 'xray' to 'solid' in GTK${gtk_version} theme..."
    sed -i 's/xray/solid/g' "$file"
    new_state="solid"
  elif grep -q "solid" "$file"; then
    echo "Switching from 'solid' to 'xray' in GTK${gtk_version} theme..."
    sed -i 's/solid/xray/g' "$file"
    new_state="xray"
  else
    echo "Error: Neither 'xray' nor 'solid' found in '$file'." >&2
    return 1
  fi

  local action
  if [[ "$new_state" == "xray" ]]; then
    action="Activated"
  else
    action="Deactivated"
  fi

  notify "GTK${gtk_version} Xray ${action}" "<i><b> </b></i>" "$iconpath"

  if [[ -x "$reload_script" ]]; then
    "$reload_script"
  else
    echo "Error: Reload script '$reload_script' not found or not executable." >&2
    return 1
  fi
}

# Main: decide which toggle to run based on the argument
case "${1:-}" in
gtk3)
  toggle_gtk_theme 3
  ;;
gtk4)
  toggle_gtk_theme 4
  ;;
gtk)
  toggle_gtk_theme 3
  toggle_gtk_theme 4
  ;;
*)
  toggle_all_xray
  ;;
esac
