clear
# --- VARIABLES ---
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
X=1
X_MAX=22

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- MESSAGE FUNCTIONS ---

echo_arrow() { echo -e "${BLUE}=> $1${NC}"; }
echo_success() { echo -e "${GREEN}✓ $1${NC}"; }
echo_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
echo_error() { echo -e "${RED}✗ $1${NC}\n"; }
print_separator() {
  echo -e "\n${CYAN}══════════════════════════════════════════════════════════════════${NC}"
  echo -e "${CYAN}($X/$X_MAX) -> $1${NC}"
  echo -e "${CYAN}══════════════════════════════════════════════════════════════════${NC}\n"
  X=$((X + 1))
}

# Script directory check
if [[ "$PWD" != "$SCRIPT_DIR" ]]; then
  echo -e "${RED}╔══════════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${RED}║Be sure to be in the same directory than the script before launching it ! ║"
  echo -e "${RED}╚══════════════════════════════════════════════════════════════════════════╝${NC}"
  exit 1
fi

# List of packages to uninstall
uninstall=(
  "gnome-console"
)

# List of default packages to install
default_packages=(
  "amd-ucode"
  "appimagelauncher"
  "archiso"
  "aria2"
  "bat"
  "bc"
  "bitwarden"
  "bluez-utils"
  "btop"
  "cargo"
  "cava"
  "cbonsai"
  "cmatrix"
  "cups"
  "dconf-editor"
  "docker"
  "docker-buildx"
  "dosfstools"
  "downgrade"
  "eww"
  "expect"
  "fastfetch"
  "fd"
  "ffmpeg"
  "figlet"
  "figlet-fonts"
  "figlet-fonts-extra"
  "file-roller"
  "fish"
  "flatpak"
  "fontforge"
  "fpc"
  "fzf"
  "gapless"
  "git"
  "google-chrome"
  "gparted"
  "grub-customizer"
  "gwenview"
  "hollywood"
  "hplip"
  "inkscape"
  "inxi"
  "imagemagick"
  "lazygit"
  "kio"
  "kio-gdrive"
  "kitty"
  "kdeconnect"
  "kdenlive"
  "jdk17-openjdk"
  "jq"
  "libre-menu-editor"
  "libreoffice-still-fr"
  "lolcat"
  "ly"
  "matugen-bin"
  "neovim"
  "nodejs-lts-iron"
  "npm"
  "ntfs-3g"
  "obs-studio"
  "obsidian"
  "okular"
  "onlyoffice-bin"
  "os-prober"
  "p7zip"
  "pavucontrol"
  "pipes.sh"
  "poppler"
  "power-profiles-daemon"
  "python-json5"
  "python-numpy"
  "python-pillow"
  "python-pynvim"
  "python-pyqt5"
  "python-scikit-image"
  "python-scikit-learn"
  "qalculate-gtk"
  "reflector"
  "reflector-simple"
  "resources"
  "ripgrep"
  "rustc"
  "shell-color-scripts-git"
  "simple-scan"
  "speedtest-cli"
  "spotify-launcher"
  "sshfs"
  "starship"
  "tmux"
  "tree-sitter-cli"
  "tty-clock"
  "ttf-fira-code"
  "ttf-font-awesome"
  "ttf-jetbrains-mono"
  "ttf-nerd-fonts-symbols"
  "vlc"
  "vdhcoapp"
  "vi"
  "vim"
  "visual-studio-code-bin"
  "wtype"
  "wget"
  "wl-clipboard"
  "xclip"
  "xorg-xhost"
  "yazi"
  "zen-browser-bin"
  "zenity"
  "zoxide"
  "zsh"
)

gnome_packages=(
  "cheese"
  "evince"
  "extension-manager"
  "gnome-calendar"
  "gnome-terminal"
  "gnome-text-editor"
  "gnome-tweaks"
  "gnome-weather"
  "loupe"
  "resources"
  "simple-scan"
)

hypr_packages=(
  "aylurs-gtk-shell"
  "blueman"
  "breeze"
  "breeze5"
  "brightnessctl"
  "clipse"
  "dolphin"
  "grim"
  "hypridle"
  "hyprland"
  "hyprlock"
  "hyprpaper"
  "hyprpicker"
  "hyprpolkitagent"
  "imagemagick"
  "kde-material-you-colors"
  "nautilus"
  "nautilus-admin-gtk4"
  "nautilus-image-converter"
  "nautilus-open-any-terminal"
  "network-manager-applet"
  "networkmanager"
  "python-poetry"
  "polkit-gnome"
  "python-pywal16"
  "qt6-wayland"
  "qt6ct-kde"
  "rofi-wayland"
  "rofi-calc-git"
  "rofi-emoji-git"
  "slurp"
  "swaync"
  "swww"
  "syshud"
  "waybar"
  "waypaper"
  "xdg-desktop-portal-gtk"
  "xdg-desktop-portal-hyprland"
)

# --- PREREQUISITE VALIDATION ---

check_prerequisite() {
  if ! command -v yay &>/dev/null; then
    echo_error "yay is not installed. Install yay before continuing."
    exit 1
  fi
}

# --- CONFIRMATION BEFORE EACH FUNCTION ---

confirm() {
  local message="$1"
  read -p "$(echo -e ${YELLOW}"$message (y/n) "${NC})" response
  if [[ "$response" != "y" ]]; then
    echo_warning "Operation skipped by the user."
    return 1
  fi
  return 0
}

# --- TASK FUNCTIONS ---

# Update package database
update_package_database() {
  print_separator "Updating package database"
  if confirm "Do you want to update the package database?"; then
    sudo pacman -Sy --quiet || {
      echo_error "Failed to update package database"
      exit 1
    }
  fi
}

# Choose the default shell
choose_shell() {
  print_separator "Default SHELL selection"
  if confirm "Do you to select your default SHELL ?"; then
    read -p "$(echo -e ${YELLOW}"Choose between bash[B] / fish[F] / zsh[anything else] : "${NC})" SH
    case $SH in
    B | b)
      sudo chsh $USER -s /bin/bash
      ;;
    F | f)
      sudo chsh $USER -s /bin/fish
      ;;
    *)
      sudo chsh $USER -s /bin/zsh
      ;;
    esac
  fi

}

# Configure clock for dual boot with Windows
config_clock() {
  print_separator "Configuring internal clock for dual boot with Windows"
  if confirm "Do you want to configure the internal clock for dual boot with Windows?"; then
    timedatectl set-local-rtc 1 --adjust-system-clock
  fi
}

# Uninstall packages with cleaner output
uninstall_packages() {
  print_separator "Uninstalling packages"
  if confirm "Do you want to uninstall the listed packages?"; then
    for pkg in "${uninstall[@]}"; do
      echo_arrow "Checking $pkg..."

      if ! pacman -Q "$pkg" &>/dev/null; then
        echo_success "$pkg is not installed"
      else
        echo_arrow "Uninstalling $pkg..."

        if yay -Rns --noconfirm "$pkg" >/dev/null 2>&1; then
          echo_success "$pkg uninstalled"
        else
          echo_error "$pkg not uninstalled"
        fi
      fi
    done
  fi
}

# Install base packages
install_default_packages() {
  print_separator "Installing base packages"
  if confirm "Do you want to install base packages?"; then
    for pkg in "${default_packages[@]}"; do
      echo_arrow "Checking $pkg..."

      if pacman -Q "$pkg" &>/dev/null; then
        echo_success "$pkg is already installed"
      else
        echo_arrow "Installing $pkg..."
        if yay -S --noconfirm --quiet "$pkg" >/dev/null 2>&1; then
          echo_success "$pkg installed"
        else
          echo_error "$pkg not installed"
        fi
      fi
    done
  fi
}

# Special ways to install some packages
G_special_installs() {
  print_separator "Special installation precess"

  # Tmux tpm
  if confirm "Do you want to install tpm (Tmux)?"; then
    echo_arrow "Tpm installation..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  # Spicetify
  if confirm "Do you want to install Spicetify?"; then
    echo_arrow "Installation of Spicetify..."
    curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
  fi

  # Hyprls (Hyprland LSP)
  if confirm "Do you want to install Hyprls (Hyprland LSP)?"; then
    git clone --recurse-submodules https://github.com/hyprland-community/hyprls /tmp/hyprls &&
      (cd /tmp/hyprls && just install)
  fi

}

# Papirus icons
papirus() {
  print_separator "Installation of papirus icon theme"
  if confirm "Do you want to install papirus icon theme?"; then
    if confirm "  On root directory?"; then
      wget -qO- https://git.io/papirus-icon-theme-install | sh
    fi
    if confirm "  On HOME directory for GTK?"; then
      wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.icons" sh
    fi
    if confirm "  On HOME directory for KDE?"; then
      wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.local/share/icons" sh
    fi
  fi
}

# Optional Group of GNOME config functions
G_gnome_config() {
  restore_gnome_config() {
    print_separator "Restoring GNOME config"
    if confirm "Do you want to restore the gnome config?"; then
      dconf load / <"$HOME/Dotfiles/gnome-settings-backup.dconf"
    fi
  }
  restore_gnome_config

  gnome_packages_install() {
    print_separator "Installing additional packages for GNOME"
    if confirm "Do you want to install the listed packages for GNOME?"; then
      for pkg in "${gnome_packages[@]}"; do
        echo_arrow "Checking $pkg..."

        if pacman -Q "$pkg" &>/dev/null; then
          echo_success "$pkg is already installed"
        else
          echo_arrow "Installing $pkg..."

          if yay -S --noconfirm --quiet "$pkg" >/dev/null 2>&1; then
            echo_success "$pkg installed"
          else
            echo_error "$pkg not installed"
          fi
        fi
      done
    fi
  }
  gnome_packages_install
}

# Edit sudoers
visudo() {
  print_separator "Visudo"
  if confirm "Do you want to edit your sudoers file?"; then
    echo -e "${CYAN}You will edit your sudoers file !"
    echo -e "${CYAN}Add a line like this : 'bnsplit ALL=(ALL) NOPASSWD: <the command that you wnant ot grant permissions>'"
    echo -ne "${CYAN}Press any key to start.."
    read c
    sudo visudo
  fi
}

# Install Megasync
install_megasync() {
  print_separator "Installing Megasync"
  if confirm "Do you want to install Megasync?"; then
    local megasync_pkg="megasync-x86_64.pkg.tar.zst"
    local megasync_url="https://mega.nz/linux/repo/Arch_Extra/x86_64/$megasync_pkg"
    cd $HOME/Downloads

    if [ ! -f "$megasync_pkg" ]; then
      echo_arrow "Downloading Megasync..."
      wget "$megasync_url" || {
        echo_error "Failed to download Megasync"
        exit 1
      }
    fi

    echo_arrow "Installing Megasync..."
    sudo pacman -U "$megasync_pkg" --noconfirm || echo_error "Failed to install Megasync"
    rm -f "$megasync_pkg"
  fi
}

# Grub customizing
grub() {
  print_separator "Grub Theming"
  if confirm "Do you want to apply a theme to grub?"; then
    echo -e "${BLUE}=> Enter a screen resolution supported by Grub (e.g., 1920x1080): ${NC}"
    echo -e "${YELLOW}⚠ Ensure the resolution is supported by Grub by running 'videoinfo' in Grub! (default : 1920x1080)${NC}"
    read -r SCREEN_RES
    SCREEN_RES=${SCREEN_RES:-1920x1080}

    echo -e "${BLUE}=> Press a key to select a theme... ${NC}"
    read -n 1

    if [[ ! -d "/boot/grub/themes/" ]]; then
      sudo mkdir -p /boot/grub/themes/
    fi

    SELECTED_FOLDER=$(ls $HOME/Dotfiles/grub-themes | fzf --height=40% --border --ansi)
    SELECTED_THEME=$(ls $HOME/Dotfiles/grub-themes/"$SELECTED_FOLDER"/ | fzf --height=40% --border --ansi)

    sudo rm -rf /boot/grub/themes/*
    sudo cp -r $HOME/Dotfiles/grub-themes/"$SELECTED_FOLDER"/ /boot/grub/themes/"$SELECTED_FOLDER"/

    sudo sed -i '/^GRUB_BACKGROUND/s/^/#/' /etc/default/grub
    sudo sed -i "s/^GRUB_GFXMODE=.*/GRUB_GFXMODE=$SCREEN_RES/" /etc/default/grub
    sudo sed -i '/^#\?GRUB_THEME/c\GRUB_THEME="/boot/grub/themes/'"$SELECTED_FOLDER/$SELECTED_THEME/theme.txt"'"' /etc/default/grub

    sudo grub-mkconfig -o /boot/grub/grub.cfg
  fi
}

# Backup archive restoration
restore_backup() {
  local ARCHIVE_BACKUP="../backup_latest/"

  if [ -d "$ARCHIVE_BACKUP" ]; then
    print_separator "Restoring backup"
    if confirm "Do you want to restore the backup?"; then
      echo_arrow "Replacing files and folders..."
      for file in "$ARCHIVE_BACKUP/$HOME/."*; do
        file_name=$(basename "$file")
        dest_file="$HOME/$file_name"

        # Check if the file is a broken symbolic link
        if [ -L "$dest_file" ] && [ ! -e "$dest_file" ]; then
          echo_warning "$dest_file is a broken symlink, deleting..."
          rm "$dest_file"
        fi

        if [ -f "$file" ] || [ -d "$file" ]; then
          echo_arrow "Copying $file_name to $HOME/"
          cp -r "$file" "$HOME/"
          echo_success "$file_name copied to $HOME/"
        fi
      done

      for file in "$ARCHIVE_BACKUP/etc/"*; do
        file_name=$(basename "$file")
        if [ -f "$file" ] || [ -d "$file_name" ]; then
          echo_arrow "Copying $file to /etc"
          sudo cp "$file" "/etc"
          echo_success "$file_name copied to /etc"
        fi
      done

      for file in "$ARCHIVE_BACKUP/boot/"*; do
        if [ -f "$file" ] || [ -d "$file" ]; then
          echo_arrow "Copying $file to /boot"
          sudo cp -r "$file" "/boot"
          echo_success "$file copied to /boot"
        fi
      done
      echo_success "Restoration complete"
    fi
  else
    echo_warning "No backup archive folder found. Proceeding to the next step."
  fi
}

# Creation of mounting points
mounting_folders() {
  folders=(
    "win"
    "usb1"
    "usb2"
  )
  print_separator "Monting folders"
  if confirm "Do you want to create mounting folders in /mnt?"; then
    echo_arrow "Creation of folders..."
    for folder in "${folders[@]}"; do
      if [ ! -d "/mnt/$folder" ]; then
        echo_arrow "Creation of $folder..."
        sudo mkdir "/mnt/$folder"
        echo_arrow "Folder created !"
      fi
    done
  fi
}

# HP printer setup
configure_printer() {
  print_separator "Printer setup"
  if confirm "Do you want to configure a printer with hp-setup -i?"; then
    sudo systemctl enable --now cups && sudo systemctl start cups && hp-setup -i || echo_error "Printer setup failed"
  fi
}

# Git setup
configure_git() {
  if [[ -f ./git_config.sh ]]; then
    print_separator "Git config"
    if confirm "Do you want to configure your git account?"; then
      source ./git_config.sh
    fi
  fi
}

# Bluetooth setup
configure_bluetooth() {
  print_separator "Bluetooth setup"
  if confirm "Do you want to configure Bluetooth?"; then
    sudo systemctl enable --now bluetooth.service
    sudo systemctl start bluetooth.service
  fi
}

# Docker Configuration
configure_docker() {
  print_separator "Configuring Docker"
  if confirm "Do you want to configure Docker?"; then
    echo_arrow "Enabling Docker service..."
    sudo systemctl enable --now docker &&
      echo_success "Docker service enabled and started" &&
      echo_arrow "adding user to docker group" &&
      sudo usermod -aG docker $USER &&
      echo_success "user added"
  fi
}

# Manual fstab editing
fstab_edit() {
  print_separator "Manual fstab editing"
  if confirm "Do you want to manually edit your /etc/fstab file?"; then
    sudo vim /etc/fstab
  fi
}

# Install/config Virtmanager with KVM/QEMU
virtmanager() {
  print_separator "Installation of Virtmanager KVM/QEMU"
  if confirm "Do you want to install and configure Virtmanager with KVM/QEMU?"; then
    bash ./kvm.sh
  fi
}

# Hyprland Configuration
hypr_config() {
  print_separator "Configuring Hyprland"
  if confirm "Do you want to configure Hyprland?"; then
    for pkg in "${hypr_packages[@]}"; do
      echo_arrow "Checking $pkg..."

      if pacman -Q "$pkg" &>/dev/null; then
        echo_success "$pkg is already installed"
      else
        echo_arrow "Installing $pkg..."

        if yay -S --noconfirm --quiet "$pkg" >/dev/null 2>&1; then
          echo_success "$pkg installed"
        else
          echo_error "$pkg not installed"
        fi
      fi
    done

    sudo systemctl enable NetworkManager
    sudo systemctl start NetworkManager
  fi
}

# Prompt to restart the system
restart() {
  print_separator "It is recommended to restart the system"
  if confirm "Do you want to restart?"; then
    sudo systemctl reboot
  fi
}

# --- MAIN EXECUTION ---
check_prerequisite
config_clock
update_package_database
uninstall_packages
install_default_packages
G_special_installs
G_gnome_config
choose_shell
papirus
install_megasync
mounting_folders
fstab_edit
visudo
restore_backup
configure_printer
configure_git
configure_bluetooth
virtmanager
configure_docker
hypr_config
grub
restart
