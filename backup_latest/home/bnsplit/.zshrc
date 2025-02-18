export PATH=$PATH:/home/bnsplit/.spicetify

# zinit init
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo

# Pour zsh-completions
fpath+=('/usr/share/zsh/site-functions')
autoload -U compinit && compinit

# Une recommandation de zinit
zinit cdreplay -q

# Keybinds
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preiew 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept

# Aliases
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
alias grep='grep --color=always'
alias yo='yay -Rns $(yay -Qdtq)'
alias yu='yay -Syu --noconfirm'
alias rmdb='sudo rm /var/lib/pacman/db.lck'
alias tka='tmux kill-session'
alias tkm='tmux kill-session -t main'
alias tm='$HOME/.config/bnsplit/scripts/tmux_launch_main.sh'

C() {
  clear &&
  colorscript -e crunch
}
ddd() {
  sudo dd bs=4M conv=fsync oflag=direct status=progress if="$1" of="$2"
}
aria16() {
  aria2c -x 16 "$1"
}
save() {
  $HOME/.config/bnsplit/scripts/save.sh
}
AnimeDive() {
  case "$1" in
    --node)
      node ~/dev/AnimeDive/src/main.js
      ;;
    *)
      source ~/dev/AnimeDive/launch-docker.sh
      ;;
  esac
}
nc() {
  SWAP_DIR="$HOME/.local/state/nvim/swap"

  if [[ -d "$SWAP_DIR" ]]; then
    rm -r "$SWAP_DIR"
    echo "Neovim swap directory removed: $SWAP_DIR"
  else
    echo "Neovim swap directory does not exist: $SWAP_DIR"
  fi
}
# Yazi integration
export EDITOR='nvim'
y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
reload_gtk_theme() {
  theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
  gsettings set org.gnome.desktop.interface gtk-theme ''
  sleep 1
  gsettings set org.gnome.desktop.interface gtk-theme $theme
}
save () {
  $HOME/.config/bnsplit/scripts/save.sh
}

# PATH
export PATH="$HOME/.local/bin:$PATH"

# Shell integration
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Starship init
eval "$(starship init zsh)"

colorscript -e crunch
# colorscript -e crunchbang-mini
# colorscript -e crunchbang
# colorscript random
