#!/usr/bin/env bash

audio() {
    local PERCENTAGE IS_MUTED
    local COLOR="\x19"
    local ICON="墳"

    PERCENTAGE=$(pacmd list-sinks |
        grep -A 15 '* index' |
        awk '/volume: /{ print $5 }' |
        grep -m 1 % |
        sed 's/[%|,]//g')

    IS_MUTED=$(pacmd list-sinks |
        grep -A 15 '* index' |
        awk '/muted:/{ print $2 }')

    if [[ "$IS_MUTED" == "no" ]]; then
        if [[ "$PERCENTAGE" -ge 70 ]]; then
            COLOR="\x16"
        elif [[ "$PERCENTAGE" -gt 10 && "$PERCENTAGE" -le 30 ]]; then
            COLOR="\x1d"
        elif [[ "$PERCENTAGE" -le 10 ]]; then
            COLOR="\x15"
            ICON=""
        fi
    else
        COLOR="\x1c"
        ICON="婢"
    fi

    printf "$COLOR %s \x0b " "$ICON"
}

audio "$@"
