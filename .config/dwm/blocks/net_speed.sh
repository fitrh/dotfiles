#!/usr/bin/env bash

parse_speed() {
    local CACHE="/tmp/dwmblocks.net_${1##*/}.cache"
    local BYTE CACHED_BYTE RAW_SPEED SPEED
    BYTE=$(<"$1")
    [[ -f "$CACHE" ]] && CACHED_BYTE=$(<"$CACHE") || CACHED_BYTE=0
    printf "%d\n" "$BYTE" > "$CACHE"
    RAW_SPEED=$(( BYTE - CACHED_BYTE ))
    SPEED=$(numfmt --to=iec --format=%.1f "$RAW_SPEED")
    printf "%s" "$SPEED"
}

parse_color() {
    [[ "$1" =~ "M" ]] && COLOR="\x10"
    [[ "$1" =~ "K" ]] && COLOR="\x0b"
    printf "%b" "${COLOR:-\x15}"
}

pretty_print() {
    printf "%s %s %7sB\x15/s \x0b" "$1" "$2" "$3"
}

net_speed() {
    [[ "$1" == -1 || -z "$1" ]] && return
    local DEVICES=("enp3s0" "wlp2s0")
    local STATISTICS="/sys/class/net/${DEVICES["$1"]}/statistics"
    local RX TX
    RX=$(parse_speed "$STATISTICS/rx_bytes")
    TX=$(parse_speed "$STATISTICS/tx_bytes")
    pretty_print "$(parse_color "$RX")" "ﯲ" "$RX"
    pretty_print "$(parse_color "$TX")" "ﯴ" "$TX"
}

net_speed "$@"
