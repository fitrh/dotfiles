#!/usr/bin/env bash

notify() {
    dunstify -a "dwmblocks" -u low -t 1000 \
        -h string:x-dunst-stack-tag:dwmblocks \
        "Network Handler" "$1"
}

get_op_state() {
    printf "%s" "$(<"/sys/class/net/$1/operstate")"
}

net_wired_get_info() {
    notify "Wired Connection"
}

net_wireless_get_strength() {
    local FILE LAST_LINE VALUES QUALITY_LINK
    mapfile -tn 0 FILE <"/proc/net/wireless"
    LAST_LINE="$(printf "%s" "${FILE[@]: -1}")"
    read -ra VALUES <<<"${LAST_LINE[@]}"
    QUALITY_LINK="$(printf "%d" "${VALUES[2]//./}")"
    printf '%d%%' $((QUALITY_LINK * 100 / 70))
}

net_wireless_get_ssid() {
    local TMP SSID
    iw wlp2s0 info >/tmp/iw_wlp2s0.info
    mapfile -tn 5 TMP </tmp/iw_wlp2s0.info
    SSID="$(printf "%s" "${TMP[4]#"${TMP[4]%%[![:space:]]*}"}")"
    printf "%s" "${SSID##ssid }"
}

net_wireless_get_info() {
    local SSID STRENGTH
    SSID="$(net_wireless_get_ssid)"
    STRENGTH="$(net_wireless_get_strength)"
    dunstify -a "dwmblocks network wireless" -u low \
        -h string:x-dunst-stack-tag:dwmblocks \
        -h string:hlcolor:"#bb9af7" \
        -h int:value:"$STRENGTH" \
        -i "network-wireless" "$SSID" "$STRENGTH"
}

left_handler() {
    [[ "$(get_op_state enp3s0)" == "up" ]] && net_wired_get_info
    [[ "$(get_op_state wlp2s0)" == "up" ]] && net_wireless_get_info
}

middle_handler() {
    for INTERFACE in "enp3s0" "wlp2s0"; do
        if [[ "$(get_op_state "$INTERFACE")" == "up" ]]; then
            exec st -c "Notify Term" \
                -t "Network Statistics" \
                -f "SF Mono:size=8.4" \
                -g 56x16 \
                -e btm --config ~/.config/bottom/net.toml
        fi
    done
    notify "No Connected Network"
}

case "$1" in
    1)
        left_handler
        ;;
    2)
        middle_handler
        ;;
    3)
        exec st -c "Float Term" \
            -f "SF Mono:size=8.4" \
            -e nmtui
        ;;
esac
