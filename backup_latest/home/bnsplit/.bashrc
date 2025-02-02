export TERMINAL=kitty

# PATH
export PATH="$HOME/.local/bin:$PATH"

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
alias nc='nvim ~/.config/'
alias f='clear && fastfetch'
alias grep='grep --color=always'
alias yo='yay -Rns $(yay -Qdtq)'
alias yu='yay -Syu --noconfirm'
alias rmdb='sudo rm /var/lib/pacman/db.lck'
alias tk='tmux kill-session'

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
