#!/bin/bash

# Color variables (exported)
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export CYAN='\033[0;36m'
export NC='\033[0m' # No Color

# --- MESSAGE FUNCTIONS ---
echo_arrow() { echo -e "${BLUE}=> $1${NC}"; }
echo_success() { echo -e "${GREEN}✓ $1${NC}"; }
echo_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
echo_error() { echo -e "${RED}✗ $1${NC}\n"; }

print_separator() {
  echo -e "\n${CYAN}══════════════════════════════════════════════════════════════════${NC}"
  echo -e "${CYAN}-> $1${NC}"
  echo -e "${CYAN}══════════════════════════════════════════════════════════════════${NC}\n"
}

confirm() {
  local message="$1"
  read -rp "$(echo -e "${YELLOW}$message (y/n) ${NC}")" response
  if [[ "$response" != "y" ]]; then
    echo_warning "Operation skipped by the user."
    return 1
  fi
  return 0
}

# Export all functions
export -f echo_arrow echo_success echo_warning echo_error print_separator confirm
