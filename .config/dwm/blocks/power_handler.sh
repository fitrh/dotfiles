#!/usr/bin/env bash

left_handler() {
    local BATTERY="/sys/class/power_supply/BAT1"
    local STATUS CAPACITY
    local ICON="gnome-power-manager"
    local APP_NAME="dwmblocks power handler"
    local TAG="battery"
    STATUS="$(<"$BATTERY/status")"
    CAPACITY="$(<"$BATTERY/capacity")"
    if [[ "$STATUS" != "Discharging" ]]; then
        ICON="preferences-power"
        TAG="charging"
    fi

    dunstify -a "$APP_NAME $TAG" -t 5000 \
        -i "$ICON" \
        -h string:x-dunst-stack-tag:dwmblocks \
        -h int:value:"$CAPACITY" "$CAPACITY%"
}

middle_handler() {
    local STATE="${XDG_STATE_HOME:-$HOME/.local/state}"
    local NIGHT_MODE="${STATE}/dwm/night_mode"
    local CLIGHT_STATE="${STATE}/clightctl"
    local APP_NAME="dwmblocks power handler"
    local IS_NIGHT_MODE MODE BACKLIGHT_LEVEL GAMMA_LEVEL

    BACKLIGHT_LEVEL="$(<"${CLIGHT_STATE}/backlight")"
    GAMMA_LEVEL="$(<"${CLIGHT_STATE}/gamma")"
    IS_NIGHT_MODE="$(<"$NIGHT_MODE")"

    if "$IS_NIGHT_MODE"; then
        printf "%s" false > "$NIGHT_MODE"

        clightctl gamma set 6500
        clightctl backlight set "$BACKLIGHT_LEVEL"

        APP_NAME="$APP_NAME daylight"
        MODE="Daylight"
    else
        printf "%s" true > "$NIGHT_MODE"

        [[ "$GAMMA_LEVEL" -gt 4500 ]] && GAMMA_LEVEL=4500
        [[ "$BACKLIGHT_LEVEL" -gt 60 ]] && BACKLIGHT_LEVEL=60

        clightctl gamma set "$GAMMA_LEVEL"
        clightctl backlight set "$BACKLIGHT_LEVEL"

        APP_NAME="$APP_NAME night"
        MODE="Night"
    fi

    clightctl notify
    dunstify -a "$APP_NAME" -t 4900 \
        -h string:x-dunst-stack-tag:dwmblocks \
        "$MODE"
}

case "$1" in
    1)
        left_handler
        ;;
    2)
        middle_handler
        ;;
    3)
        clightctl notify "clightctl" "string:none:none" "dwmblocks"
        ;;
esac

sigdwmblocks 2
