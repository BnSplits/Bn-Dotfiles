#!/bin/bash
theme='custom-adw'
gsettings set org.gnome.desktop.interface gtk-theme '' &&
gsettings set org.gnome.desktop.interface gtk-theme "$theme"
# gsettings set org.gnome.desktop.interface gtk-theme "$RANDOM"
