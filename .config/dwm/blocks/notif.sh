#!/usr/bin/env bash

notif() {
    local IN_HISTORY_LOG PAUSED
    local HISTORY_LOG="/tmp/dwmblocks.notif.cache"
    local COLOR="\x15"
    local ICON=" "

    [[ -f "$HISTORY_LOG" ]] &&
        IN_HISTORY_LOG=$(<"$HISTORY_LOG") ||
        IN_HISTORY_LOG=0
    PAUSED=$(dunstctl is-paused)

    if "$PAUSED" || [[ "$1" -eq 1 ]]; then
        COLOR="\x1c"
        ICON=" "
    elif [[ "$IN_HISTORY_LOG" -gt 0 ]]; then
        COLOR="\x0b"
        ICON=" "
    fi

    printf "$COLOR %s " "$ICON"
}

notif "$@"
