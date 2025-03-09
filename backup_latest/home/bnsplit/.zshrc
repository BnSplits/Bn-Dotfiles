# ========================
# Environment Variables
# ========================
export PATH=$PATH:/home/bnsplit/.spicetify
export EDITOR='nvim'
export PATH="$HOME/.local/bin:$PATH"

# ========================
# Zinit Plugin Manager
# ========================
# Initialize zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ========================
# Plugin Configuration
# ========================
# Load plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load OMZ snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo

# Completion system setup
fpath+=('/usr/share/zsh/site-functions')
autoload -U compinit && compinit
zinit cdreplay -q  # Replay compdefs

# ========================
# Keybindings
# ========================
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# ========================
# History Configuration
# ========================
HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# ========================
# Completion Styling
# ========================
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preiew 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ========================
# Aliases
# ========================
alias ls='ls --color'
alias z='clear && zsh'
alias b='clear && bash'
alias n='nvim'
alias c='clear'
alias ccc='colorscript'
alias cd..='cd ..'
alias cd-='cd -'
alias nz='nvim ~/.zshrc'
alias f='clear && fastfetch'
alias fl='clear && fastfetch | lolcat'
alias grep='grep --color=always'
alias yo='yay -Rns $(yay -Qdtq)'
alias yu='yay -Syu --noconfirm'
alias rmdb='sudo rm /var/lib/pacman/db.lck'
alias tka='tmux kill-session'
alias tkm='tmux kill-session -t main'
alias tm='$HOME/.config/bnsplit/scripts/tmux_launch_main.sh'

# ========================
# Custom Functions
# ========================

# Clear screen and show crunch colorscript
C() {
  clear &&
  colorscript -e crunch
}

# Enhanced dd command with progress
ddd() {
  sudo dd bs=4M conv=fsync oflag=direct status=progress if="$1" of="$2"
}

# Download with 16 connections using aria2c
aria16() {
  aria2c -x 16 "$1"
}

# Save current configuration
save() {
  $HOME/.config/bnsplit/scripts/save.sh
}

# Manage AnimeDive application
AnimeDive() {
  case "$1" in
    --node)
      # Run node version
      node ~/dev/AnimeDive/src/main.js
      ;;
    *)
      # Default docker launch
      source ~/dev/AnimeDive/launch-docker.sh
      ;;
  esac
}

# Clean neovim swap files
nc() {
  SWAP_DIR="$HOME/.local/state/nvim/swap"

  if [[ -d "$SWAP_DIR" ]]; then
    rm -r "$SWAP_DIR"
    echo "Neovim swap directory removed: $SWAP_DIR"
  else
    echo "Neovim swap directory does not exist: $SWAP_DIR"
  fi
}

# Wallhaven wallpaper downloader
wallhaven(){
  "$HOME/.config/bnsplit/scripts/wallhaven.sh" categories=110 purity=110 ratios=landscape sorting=toplist topRange=1d max=24 "$@"
}

# Yazi file manager integration
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Reload GTK theme
reload_gtk_theme() {
  theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
  gsettings set org.gnome.desktop.interface gtk-theme ''
  sleep 1
  gsettings set org.gnome.desktop.interface gtk-theme $theme
}

# Set random Gruvbox SDDM wallpaper
sddm_random_wall() {
  local source_dir="/home/bnsplit/Pictures/SDDM"
  local dest="/usr/share/sddm/themes/bnsplit-gruv/backgrounds/background"
  local resolved_source dest_dir files random_file

  resolved_source=$(readlink -f "$source_dir" || echo "$source_dir")
  [[ ! -d "$resolved_source" ]] && echo "Error: Source directory not found" >&2 && return 1

  dest_dir=$(dirname "$dest")
  [[ ! -d "$dest_dir" ]] && echo "Error: Destination directory not found" >&2 && return 1

  files=("${resolved_source}"/*(.))
  [[ ${#files[@]} -eq 0 ]] && echo "Error: No images found" >&2 && return 1

  random_file=${files[$((RANDOM % ${#files[@]} + 1))]}
  # pkexec cp -f "$random_file" "$dest" && echo "SDDM wallpaper updated: ${random_file:t}"
  sudo cp -f "$random_file" "$dest" && echo "SDDM wallpaper updated: ${random_file:t}"
}

# Interactive SDDM wallpaper selection
sddm_choose_wall() {
  local source_dir="/home/bnsplit/Pictures/SDDM"
  local dest="/usr/share/sddm/themes/bnsplit-gruv/backgrounds/background"
  local resolved_source selected_file

  # Use argument as source image if provided
  if [[ $# -gt 0 ]]; then
    selected_file=$(readlink -e "$1")
    if [[ -f "$selected_file" ]]; then
      sudo cp -f "$selected_file" "$dest" && echo "New background: ${selected_file:t}"
      return $?
    else
      echo "Error: File not found: $1" >&2
      return 1
    fi
  fi

  # Original directory selection behavior
  resolved_source=$(readlink -e "$source_dir" || echo "$source_dir")
  [[ ! -d "$resolved_source" ]] && echo "Error: Directory not found" >&2 && return 1

  selected_file=$(find -L "$resolved_source" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.png' \) -print0 | \
    fzf --ansi --border --read0 --prompt="  Select SDDM background: " \
    --header=$'󰄛  Preview 󰄛\n↑↓ - Navigate | ↵ - Select | ESC - Cancel')

  [[ -n "$selected_file" ]] && sudo cp -f "$selected_file" "$dest" && echo "New background: ${selected_file:t}"
}

# Make files executable
c+x() {
  chmod +x $@
}

# Gruvbox factory
gruvbox_factory() {
  local venv="$HOME/.config/bnsplit/scripts/gruvbox-factory/venv/bin/activate"

  if [[ ! -f "$venv" ]]; then
    echo "Virtual environment not found: $venv" >&2
    return 1
  fi

  (
    source "$venv" && gruvbox-factory "$@"
  )
}

# ========================
# Shell Integrations
# ========================
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"

# ========================
# Startup Command
# ========================
colorscript -e crunch
# colorscript -e crunchbang-mini
# colorscript -e crunchbang
# colorscript random
