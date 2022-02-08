#!/usr/bin/env bash

set_backlight_gamma() (
    local BACKLIGHT GAMMA HOUR
    local STATE="${XDG_STATE_HOME:-$HOME/.local/state}"
    local NIGHT_MODE="$STATE/clightctl/is_night_mode"
    local CLIGHT_STATE="$STATE/clightctl"
    HOUR=$(date +"%-H")
    BACKLIGHT=$(<"$CLIGHT_STATE/backlight")
    BACKLIGHT=$(bc <<<"scale=0; $BACKLIGHT * 100 / 1")
    GAMMA=$(<"$CLIGHT_STATE/gamma")

    if [[ "$HOUR" -ge 20 || "$HOUR" -lt 8 ]]; then
        [[ "$GAMMA" -ge 6400 ]] && GAMMA=4500
        [[ "$BACKLIGHT" -ge 40 ]] && BACKLIGHT=20
        IS_NIGHT=true
    else
        [[ "$GAMMA" -lt 6400 ]] && GAMMA=6400
        [[ "$BACKLIGHT" -lt 50 ]] && BACKLIGHT=50
    fi

    clightctl backlight set "$BACKLIGHT"
    clightctl gamma set "$GAMMA"
    printf "%s" "${IS_NIGHT:-false}" >"$NIGHT_MODE"
)

set_backlight_gamma
