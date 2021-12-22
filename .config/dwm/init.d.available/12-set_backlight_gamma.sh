#!/usr/bin/env bash

set_backlight_gamma() (
    local BACKLIGHT GAMMA HOUR
    local STATE="${XDG_STATE_HOME:-$HOME/.local/state}/clightctl"
    HOUR=$(date +"%-H")
    BACKLIGHT=$(<"$STATE/backlight")
    BACKLIGHT=$(bc <<<"scale=0; $BACKLIGHT * 100 / 1")
    GAMMA=$(<"$STATE/gamma")

    if [[ "$HOUR" -gt 20 || "$HOUR" -lt 8 ]]; then
        [[ "$GAMMA" -ge 6400 ]] && GAMMA=4500
        [[ "$BACKLIGHT" -ge 40 ]] && BACKLIGHT=20
    else
        [[ "$GAMMA" -lt 6400 ]] && GAMMA=6400
        [[ "$BACKLIGHT" -lt 50 ]] && BACKLIGHT=50
    fi

    clightctl backlight set "$BACKLIGHT"
    clightctl gamma set "$GAMMA"
)

set_backlight_gamma
