<div align="center">
  <h1 align="center">🌀 BnSplit'ss Dotfiles</h1>
  <p align="center">A self-made Hyprland environment with dynamic theming magic</p>

  <!-- ![Hyprland](https://img.shields.io/badge/HYPRLAND-REPLACE_HYPR_VER-blueviolet?style=flat&logo=linux&logoColor=white) -->
  <!-- ![Neovim](https://img.shields.io/badge/Neovim-REPLACE_NVIM_VER-green?style=flat&logo=neovim) -->
  ![License](https://img.shields.io/badge/License-MIT-yellow?style=flat)

  [![Screenshot Gallery](./screenshots/1.png)](./screenshots)
</div>

---

## ✨ **Dynamic Chroma System**
A bespoke theming engine that transforms your desktop based on wallpaper colors:

> "The system automatically generates matching themes for:
> - GTK Applications
> - Waybar
> - Terminal color schemes
> - Rofi menus
> - AGS components"

---

## 🛠 **Core Components**
| Component          | Description                          | 
|--------------------|--------------------------------------|
| **Hyprland**       | You know what it is   |
| **Neovim**         | Tweaked LazyVim          |
| **Astal (AGS)**    | Modernized widget system             |
| **Waybar**         | Dynamic status bar with theming      |
| **Kitty**          | GPU-accelerated terminal emulator    |
| **ZSH**            | Productivity-optimized shell         |

---

## 🎨 **Screenshot Gallery**
<div align="center" style="column-count: 2; column-gap: 20px;">
  <img src="./screenshots/1.png" width="400">
  <img src="./screenshots/2.png" width="400">
  <img src="./screenshots/3.png" width="400">
  <img src="./screenshots/4.png" width="400">
  <img src="./screenshots/5.png" width="400">
  <img src="./screenshots/6.png" width="400">
  <!-- Continue up to 20 screenshots -->
</div>

---

## ⚡ **Quick Start**
### Requirements
- **Fonts**: [Vina Sans](https://fonts.google.com/specimen/Vina+Sans), [JetBrains Mono](https://www.jetbrains.com/lp/mono/)
- **Compositor**: Hyprland (latest)

### Installation
```bash
git clone --depth=1 https://github.com/BnSplits/Bn-Dotfiles.git
cd Bn-Dotfiles
chmod +x Scripts/setup.sh
./Scripts/setup.sh --install
```

---

## 🧩 **System Architecture**
```mermaid
graph TD
  A[Wallpaper] --> B(Color Generator)
  B --> C{Color Templates}
  C --> D[GTK Apps]
  C --> E[Hyprland Borders]
  C --> F[Terminal Schemes]
  C --> G[Widgets]
```

---

## 📜 **License**
Released under [MIT License](./LICENSE) - feel free to remix and redistribute!

> *"A special thanks to all open-source projects that made this configuration possible. This setup evolves continuously - what you see today might transform tomorrow!"*
