#!/usr/bin/env bash
# Arch Linux Webcam Script (V4L2 + PulseAudio)
# Usage: ./webcam_share.sh [video-sound|video-no-sound|picture]

# Generate filename with timestamp
generate_filename() {
  echo "/tmp/$(date +'%Y-%m-%d_%H-%M-%S').$1"
}

# Send to KDE Connect (keep your working version)
send_to_devices() {
  local target=$1
  local connected_devices
  connected_devices=$(kdeconnect-cli -a | grep -oP '(?<=: )[a-zA-Z0-9_-]+(?= \(paired and reachable\))' 2>/dev/null)

  if [ -z "$connected_devices" ]; then
    echo "No KDE Connect devices found"
    return 1
  fi

  for device in $connected_devices; do
    echo "Sending to $device"
    kdeconnect-cli --share "$target" -d "$device"
  done
}

# Main capture function with VIDIOC_QBUF fix
case $1 in
video-sound)
  output=$(generate_filename "mp4")
  ffmpeg -hide_banner -loglevel error \
    -f v4l2 -input_format mjpeg -framerate 30 \
    -video_size 1280x720 -fflags nobuffer \
    -use_wallclock_as_timestamps 1 -thread_queue_size 512 \
    -i /dev/video0 \
    -f pulse -i default \
    -t 3 \
    -c:v libx264 -preset fast -crf 22 \
    -c:a aac -b:a 192k \
    -y "$output"
  ;;

video-no-sound)
  output=$(generate_filename "mp4")
  ffmpeg -hide_banner -loglevel error \
    -f v4l2 -input_format mjpeg -framerate 30 \
    -video_size 1280x720 -fflags nobuffer \
    -use_wallclock_as_timestamps 1 -thread_queue_size 512 \
    -i /dev/video0 \
    -t 3 \
    -c:v libx264 -preset fast -crf 22 \
    -y "$output"
  ;;

picture)
  output=$(generate_filename "jpg")
  ffmpeg -hide_banner -loglevel error \
    -f v4l2 -input_format mjpeg \
    -video_size 1280x720 -i /dev/video0 \
    -frames:v 1 \
    -y "$output"
  ;;

*)
  echo "Usage: $0 [video-sound|video-no-sound|picture]"
  exit 1
  ;;
esac

# Share if successful
if [ -f "$output" ]; then
  send_to_devices "$output"
  echo "Capture saved: $output"
else
  echo "Failed to create capture"
  exit 1
fi
