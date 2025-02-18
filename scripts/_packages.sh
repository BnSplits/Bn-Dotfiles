#!/bin/bash

# List of packages to uninstall
export UNINSTALL_PKGS="
   gnome-console
   emacs
"

# List of default packages to install
export BASE_PKGS="
  alsa-utils
  amd-ucode
  appimagelauncher
  archiso
  aria2
  bat
  bc
  bitwarden
  bluez-utils
  btop
  cantarell-fonts
  cargo
  cava
  cbonsai
  cmatrix
  cups
  dconf-editor
  docker
  docker-buildx
  dosfstools
  downgrade
  eww
  expect
  fastfetch
  fd
  ffmpeg
  figlet
  figlet-fonts
  figlet-fonts-extra
  file-roller
  fish
  flatpak
  fontforge
  fpc
  fzf
  gapless
  git
  google-chrome
  gparted
  grub-customizer
  gwenview
  hollywood
  hplip
  inkscape
  inxi
  imagemagick
  lazygit
  kio
  kio-gdrive
  kitty
  kdeconnect
  kdenlive
  jdk17-openjdk
  jq
  libre-menu-editor
  libreoffice-still-fr
  lolcat
  ly
  matugen-bin
  neovim
  nodejs-lts-iron
  npm
  ntfs-3g
  obs-studio
  obsidian
  okular
  onlyoffice-bin
  os-prober
  p7zip
  pavucontrol
  pipes.sh
  poppler
  power-profiles-daemon
  python-json5
  python-numpy
  python-pillow
  python-pynvim
  python-pyqt5
  python-scikit-image
  python-scikit-learn
  qalculate-gtk
  reflector
  reflector-simple
  resources
  ripgrep
  rustc
  shell-color-scripts-git
  simple-scan
  speedtest-cli
  spotify-launcher
  sshfs
  starship
  tmux
  tree-sitter-cli
  tty-clock
  ttf-dejavu
  ttf-fira-code
  ttf-font-awesome
  ttf-jetbrains-mono
  ttf-nerd-fonts-symbols
  vlc
  vdhcoapp
  vi
  vim
  visual-studio-code-bin
  wtype
  wget
  wl-clipboard
  xclip
  xorg-xhost
  yazi
  zen-browser-bin
  zenity
  zoxide
  zsh
"

export GNOME_PKGS="
  cheese
  evince
  extension-manager
  gnome-calendar
  gnome-terminal
  gnome-text-editor
  gnome-tweaks
  gnome-weather
  loupe
  resources
  simple-scan
"

export HYPR_PKGS="
  aylurs-gtk-shell
  blueman
  breeze
  breeze5
  brightnessctl
  clipse
  dolphin
  grim
  hypridle
  hyprland
  hyprlock
  hyprpaper
  hyprpicker
  hyprpolkitagent
  imagemagick
  kde-material-you-colors
  nautilus
  nautilus-admin-gtk4
  nautilus-image-converter
  nautilus-open-any-terminal
  network-manager-applet
  networkmanager
  python-poetry
  polkit-gnome
  python-pywal16
  qt6-wayland
  qt6ct-kde
  rofi-wayland
  rofi-calc-git
  rofi-emoji-git
  slurp
  swaync
  swww
  syshud
  waybar
  waypaper
  xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
"
