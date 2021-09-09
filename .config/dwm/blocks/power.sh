#!/usr/bin/env bash

power() {
    local STATUS CAPACITY
    local BATTERY="/sys/class/power_supply/BAT1"
    local ICON=""
    local COLOR="\x1b"
    STATUS=$(<"$BATTERY"/status)
    CAPACITY=$(<"$BATTERY"/capacity)

    if [[ "$STATUS" != "Discharging" ]]; then
        COLOR="\x13"
        ICON=""
        # ICON="ﯓ"
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
            COLOR="\x13"
            ICON=""
        elif [[ "$CAPACITY" -ge 30 ]]; then
            COLOR="\x0e"
            ICON=""
        else
            COLOR="\x0e"
            ICON=""
        fi
    fi

    printf "$COLOR %s \x0b" "$ICON"
}

power
