#!/usr/bin/env bash

notify() {
    notify-send -a "dwmblocks" -u low -t 1000 \
        -h string:x-dunst-stack-tag:dwmblocks \
        "Network Speed Handler" "$1"
}

pretty_print() {
    local VALUE="$1"
    local LABEL="$2"
    local COLOR="$3"
    VALUE="$(numfmt --to=iec --format=%.2f "$VALUE")"
    VALUE="<span foreground='$COLOR'><b>${VALUE}B</b></span>"
    VALUE="<span foreground='$COLOR'>$LABEL</span> : $VALUE"
    printf "%s" "$VALUE"
}

left_handler() {
    local CLASS_PATH="/sys/class/net"
    local DEVICES=("enp3s0" "wlp2s0")
    local UP_DEVICES

    for DEVICE in "${DEVICES[@]}"; do
        local IS_UP
        IS_UP="$(<"$CLASS_PATH/$DEVICE/operstate")"
        [[ "$IS_UP" == "up" ]] && UP_DEVICES+=("$DEVICE")
    done

    for DEVICE in "${UP_DEVICES[@]}"; do
        local RX TX
        RX="$(<"$CLASS_PATH/$DEVICE/statistics/rx_bytes")"
        TX="$(<"$CLASS_PATH/$DEVICE/statistics/tx_bytes")"
        RX="$(pretty_print "$RX" "Received   " "#bb9af7")"
        TX="$(pretty_print "$TX" "Transferred" "#ff9e64")"
        notify-send -a "dwmblocks network traffic" -u low \
            -h string:x-dunst-stack-tag:dwmblocks \
            -i "network-wireless" "$DEVICE" "$RX\n$TX"
    done
}

case "$1" in
    1)
        left_handler
        ;;
    2)
        notify "Middle Button"
        ;;
    3)
        notify "Right Button"
        ;;
esac
