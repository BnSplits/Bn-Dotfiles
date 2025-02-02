#!/bin/bash

iconpath="$HOME/.icons/Papirus/64x64/apps/sleep.svg"

if pgrep -x "hypridle" > /dev/null
then
    pkill -x "hypridle"
    notify-send -a "System" "Inhibitor ON ! " "<i><b> </b></i>" -i "$iconpath"  -t "5000"
else
    hypridle &
    notify-send -a "System" "Inhibitor OFF ! " "<i><b> </b></i>" -i "$iconpath"  -t "5000"
fi
