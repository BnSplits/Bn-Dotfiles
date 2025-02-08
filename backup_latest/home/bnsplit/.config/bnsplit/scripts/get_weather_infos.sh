#!/bin/bash

while [[ true ]]; do
  # Cache directory
  CACHE_DIR="$HOME/.config/bnsplit/cache"
  CACHE_FILE="$CACHE_DIR/current-weather"

  # Check if the cache directory exists, otherwise create it
  mkdir -p "$CACHE_DIR"

  # Get location (latitude, longitude)
  LOCATION=$(curl -s ipinfo.io/loc)
  if [[ -z "$LOCATION" ]]; then
    exit 1 # Exit if location is not found
  fi

  # Get city name
  CITY=$(curl -s ipinfo.io/city)
  if [[ -z "$CITY" ]]; then
    exit 1
  fi

  # Get weather data
  WEATHER_DATA=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${LOCATION%,*}&longitude=${LOCATION#*,}&current_weather=true")
  if [[ -z "$WEATHER_DATA" ]]; then
    exit 1
  fi

  # Extract required information
  TEMP=$(echo "$WEATHER_DATA" | jq -r '.current_weather.temperature')
  WEATHER_CODE=$(echo "$WEATHER_DATA" | jq -r '.current_weather.weathercode')

  # Check if values are valid
  if [[ -z "$TEMP" || -z "$WEATHER_CODE" ]]; then
    exit 1
  fi

  # Map weather codes to states and icons
  declare -A WEATHER_MAP=(
    [0]="☀️ Clear"
    [1]="🌤 Partly Cloudy"
    [2]="⛅ Cloudy"
    [3]="☁️ Overcast"
    [45]="🌫 Fog"
    [48]="🌫 Dense Fog"
    [51]="🌦 Light Drizzle"
    [53]="🌧 Drizzle"
    [55]="🌧 Heavy Drizzle"
    [61]="🌦 Light Rain"
    [63]="🌧 Rain"
    [65]="🌧 Heavy Rain"
    [71]="🌨 Light Snow"
    [73]="❄️ Snow"
    [75]="❄️ Heavy Snow"
    [95]="⛈ Thunderstorm"
    [99]="⛈ Severe Thunderstorm"
  )

  WEATHER=${WEATHER_MAP[$WEATHER_CODE]:-"🌡 Unknown"}

  # Write output to the cache file
  # echo "$CITY: ${TEMP}° $WEATHER" >"$CACHE_FILE"
  echo "${TEMP}° $WEATHER" >"$CACHE_FILE"

  sleep 300
done
