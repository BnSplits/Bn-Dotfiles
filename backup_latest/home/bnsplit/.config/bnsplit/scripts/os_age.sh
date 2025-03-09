#!/bin/bash

# Retrieve the date of the oldest file (assumed to be the system installation date)
# Date format: year-month-day

case "$1" in
home)
  install_date=$(ls -lct --time-style=long-iso /home/ | tail -1 | awk '{print $6, $7}')
  ;;
*)
  install_date=$(ls -lct --time-style=long-iso / | tail -3 | awk 'NR==1' | awk '{print $6, $7}')
  ;;
esac

# Convert the installation date to seconds since Epoch
install_seconds=$(date -d "$install_date" +%s)

# Get the current date in seconds since Epoch
current_seconds=$(date +%s)

# Calculate the difference in seconds
diff_seconds=$((current_seconds - install_seconds))

# Convert the difference to days, hours, minutes, and seconds
diff_days=$((diff_seconds / 86400))
diff_hours=$(((diff_seconds % 86400) / 3600))
diff_minutes=$(((diff_seconds % 3600) / 60))
diff_seconds=$((diff_seconds % 60))

# Display the elapsed time
echo "$diff_days days, $diff_hours hours, $diff_minutes mins, $diff_seconds secs"
# echo "$diff_days days, $diff_hours hours, $diff_minutes mins"
