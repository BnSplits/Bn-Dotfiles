#!/bin/sh
sed -n 1p ~/.themes/custom-adw/gtk-4.0/colors.css | grep xray &>/dev/null && echo true || echo false
