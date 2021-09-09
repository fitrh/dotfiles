#!/usr/bin/env bash

battery() {
  local STATUS CAPACITY
  local BATTERY="/sys/class/power_supply/BAT1"
  local ICON=""
  STATUS=$(cat "$BATTERY"/status)
  CAPACITY=$(cat "$BATTERY"/capacity)

  if [[ "$STATUS" != "Discharging" ]]; then
    ICON=""
  else
    if [[ "$CAPACITY" -eq 100 ]]; then
      ICON=""
    elif [[ "$CAPACITY" -ge 90 ]]; then
      ICON=""
    elif [[ "$CAPACITY" -ge 80 ]]; then
      ICON=""
    elif [[ "$CAPACITY" -ge 70 ]]; then
      ICON=""
    elif [[ "$CAPACITY" -ge 60 ]]; then
      ICON=""
    elif [[ "$CAPACITY" -ge 50 ]]; then
      ICON=""
    elif [[ "$CAPACITY" -ge 40 ]]; then
      ICON=""
    elif [[ "$CAPACITY" -ge 30 ]]; then
      ICON=""
    else
      ICON=""
    fi
  fi
  printf "%s %3d%%" "$ICON" "$CAPACITY"
}

timedate() {
  local FORMAT
  FORMAT=$(date +" %a, %d %b [%I:%M %p]")
  printf "%s" "$FORMAT"
}

network_status() {
  local GENERAL CONNECTION SPEED
  local ICON=""
  local STATUS="disconnected"
  SPEED=$(network_speed)

  IFS=":"
  GENERAL=$(nmcli -f STATE,CONNECTIVITY -t general)
  read -a GENERAL <<< "$GENERAL"
  CONNECTION=$(nmcli -f NAME,TYPE,DEVICE -t connection show --active)
  read -a CONNECTION <<< "$CONNECTION"
  IFS=" "

  local STATE="${GENERAL[0]}"
  [[ "$STATE" =~ "connected" ]] && [[  "$STATE" != "disconnected" ]] && {
    STATUS="${CONNECTION[0]}"
    local TYPE="${CONNECTION[1]}"
    local CONNECTIVITY="${GENERAL[1]}"

    if [[ $CONNECTIVITY != "full" ]]; then
      if [[ "$TYPE" =~ "wireless" ]]; then
        ICON="睊"
      else
        ICON=""
      fi
    else
      SPEED=$(network_speed "${CONNECTION[2]}")
      if [[ "$TYPE" =~ "wireless" ]]; then
        ICON="直"
      else
        ICON=""
      fi
    fi
  }

  printf "%s" "$SPEED $ICON $STATUS"
}

network_speed() {
  local ACTIVE_DEVICE="$1"

  if [[ -n "$ACTIVE_DEVICE" ]]; then
    local DEVICE_STATE RECEIVED TRANSMITTED
    local NEW_DEVICE_STATE NEW_RECEIVED NEW_TRANSMITTED
    local DO_SPEED UP_SPEED
    DEVICE_STATE=$(rg "$ACTIVE_DEVICE" /proc/net/dev)
    RECEIVED=$(echo "$DEVICE_STATE" | awk '{printf $2}')
    TRANSMITTED=$(echo "$DEVICE_STATE" | awk '{printf $10}')
    sleep 1s
    NEW_DEVICE_STATE=$(rg "$ACTIVE_DEVICE" /proc/net/dev)
    NEW_RECEIVED=$(echo "$NEW_DEVICE_STATE" | awk '{printf $2}')
    NEW_TRANSMITTED=$(echo "$NEW_DEVICE_STATE" | awk '{printf $10}')
    DO_SPEED=$(numfmt --to=iec $((NEW_RECEIVED-RECEIVED)))
    UP_SPEED=$(numfmt --to=iec $((NEW_TRANSMITTED-TRANSMITTED)))

    printf "[ %4sB/s |  %4sB/s]" "$DO_SPEED" "$UP_SPEED"
  fi
}

volume() {
  local PERCENTAGE MUTE
  PERCENTAGE=$(amixer -D pulse sget Master \
    | grep -Po "\[\K(\d+)" \
    | head -n 1)
  MUTE=$(amixer -D pulse sget Master \
    | tail -1 \
    | awk '{print $6}' \
    | sed 's/[^a-z]*//g')
  if [[ "$MUTE" != "off" ]]; then
    if [[ "$PERCENTAGE" -ge 70 ]]; then
      ICON="墳"
    elif [[ "$PERCENTAGE" -ge 40 ]]; then
      ICON="奔"
    elif [[ "$PERCENTAGE" -ge 10 ]]; then
      ICON=""
    else
      ICON=""
    fi
  else
    ICON="婢"
  fi
  printf "%s %3d%%" "$ICON" "$PERCENTAGE"
}

dwmbar() {
  local SEPARATROR=" "
  while true; do
    STATUS=$(network_status)
    STATUS="$STATUS $SEPARATROR $(volume)"
    STATUS="$STATUS $SEPARATROR $(battery)"
    STATUS="$STATUS $SEPARATROR $(timedate)"
    xsetroot -name " $STATUS "
    sleep 1s
  done
}

dwmbar &
