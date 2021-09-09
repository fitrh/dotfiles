#!/usr/bin/env bash

set_backlight_gamma() {
    local BACKLIGHT GAMMA
    local STATE="${XDG_STATE_HOME:-$HOME/.local/state}/clightctl"
    BACKLIGHT="$(<"${STATE}/backlight")"
    GAMMA="$(<"${STATE}/gamma")"

    clightctl backlight set "$BACKLIGHT"
    clightctl gamma set "$GAMMA"
}

set_backlight_gamma
