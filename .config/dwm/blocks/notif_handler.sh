#!/usr/bin/env bash

notify() {
    local MESSAGE="$1"
    local TIMEOUT="${2:-2000}"
    dunstify -i "preferences-desktop-notification" \
        -h string:x-dunst-stack-tag:dwmblocks \
        -t "$TIMEOUT" "$MESSAGE"
    sigdwmblocks 5
}

left_handler() {
    local IN_HISTORY_LOG DISPLAYED
    local HISTORY_LOG="/tmp/dwmblocks.notif.cache"

    [[ -f "$HISTORY_LOG" ]] &&
        IN_HISTORY_LOG=$(<"$HISTORY_LOG") ||
        IN_HISTORY_LOG=0

    DISPLAYED="$(dunstctl count displayed)"

    if [[ "$IN_HISTORY_LOG" -eq 0 && "$DISPLAYED" -eq 0 ]]; then
        notify "Empty Notification" && sleep 2s
        printf "%d" 0 >"$HISTORY_LOG"
    elif [[ "$IN_HISTORY_LOG" -gt 0 ]]; then
        dunstctl history-pop
        dunstctl count history >"$HISTORY_LOG"
        sigdwmblocks 5
    elif [[ "$DISPLAYED" -gt 0 ]]; then
        dunstctl close-all
        notify "Close All Notification" 1000
        printf "%d" 0 >"$HISTORY_LOG"
        sigdwmblocks 5
    fi
}

middle_handler() {
    local SIGVAL=1
    local STATE="Disabled"

    eval "$(dunstctl is-paused)" && SIGVAL=0 && STATE="Enabled"

    notify "Notification $STATE" && sigdwmblocks 5 "$SIGVAL"
    [[ "$STATE" == "Disabled" ]] && sleep 1s
    dunstctl set-paused toggle
}

right_handler() {
    local IN_HISTORY_LOG DISPLAYED
    local HISTORY_LOG="/tmp/dwmblocks.notif.cache"
    [[ -f "$HISTORY_LOG" ]] && IN_HISTORY_LOG=$(<"$HISTORY_LOG")
    DISPLAYED="$(dunstctl count displayed)"

    if [[ "$DISPLAYED" -eq 0 && "$IN_HISTORY_LOG" -eq 0 ]]; then
        notify "Empty Notification" && sleep 2s
        printf "%d" 0 >"$HISTORY_LOG"
    elif [[ "$DISPLAYED" -gt 0 ]]; then
        dunstctl close-all
        notify "Close All Notification"
    elif [[ "$(dunstctl count history)" -gt 0 ]]; then
        notify "Clear Notification History"
        printf "%d" 0 >/tmp/dwmblocks.notif.cache && sigdwmblocks 5
    fi
}

case "$1" in
    1)
        left_handler
        ;;
    2)
        middle_handler
        ;;
    3)
        right_handler
        ;;
esac
