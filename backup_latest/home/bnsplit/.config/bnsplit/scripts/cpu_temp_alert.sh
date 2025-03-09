#!/bin/bash

# Alert thresholds
HIGH_ALERT=75
CRITICAL_ALERT=80
EMERGENCY_ALERT=90

# Notification settings
ICON_PATH="$HOME/.icons/Papirus/48x48/status"
ALERT_ICON="$ICON_PATH/dialog-error.svg"
WARNING_ICON="$ICON_PATH/dialog-warning.svg"
URGENT_ICON="$ICON_PATH/dialog-error.svg"

# Alert state flags
alerted_high=0
alerted_critical=0
alerted_emergency=0

while true; do
    # Get current CPU temperature
    cpu_temp=$(sensors | awk '/^Tctl:/ {print $2}' | sed 's/[+°C]//g' | xargs printf "%.0f")
    
    # Emergency alert (90°C)
    if [ $cpu_temp -ge $EMERGENCY_ALERT ]; then
        if [ $alerted_emergency -eq 0 ]; then
            notify-send -a "System" "EMERGENCY TEMPERATURE!" "CPU at ${cpu_temp}°C - IMMEDIATE SHUTDOWN!" \
            -i "$URGENT_ICON" -t 30000 -u critical
            alerted_emergency=1
        fi
        # Reset lower alerts
        alerted_critical=0
        alerted_high=0
        
        # Critical alert (80°C)
        elif [ $cpu_temp -ge $CRITICAL_ALERT ]; then
        if [ $alerted_critical -eq 0 ]; then
            notify-send -a "System" "CRITICAL TEMPERATURE!" "CPU at ${cpu_temp}°C - Check cooling system!" \
            -i "$ALERT_ICON" -t 20000 -u critical
            alerted_critical=1
        fi
        # Reset lower alert
        alerted_high=0
        
        # High temperature alert (75°C)
        elif [ $cpu_temp -ge $HIGH_ALERT ]; then
        if [ $alerted_high -eq 0 ]; then
            notify-send -a "System" "High Temperature Alert" "CPU at ${cpu_temp}°C - Monitor system" \
            -i "$WARNING_ICON" -t 10000 -u normal
            alerted_high=1
        fi
        
        # Reset all alerts if below all thresholds
    else
        alerted_high=0
        alerted_critical=0
        alerted_emergency=0
    fi
    
    sleep 5 # Check every 5 seconds
done
