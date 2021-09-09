#!/usr/bin/env bash

right_handler() {
    sigdwmblocks 4
    st -c "Notify Term" -T "ncpamixer" \
        -f "SF Mono:size=10" -g 61x20 \
        -e fish -c "ncpamixer -t o"
}

case "$1" in
    1)
        volctl "" "dwmblocks"
        ;;
    2)
        volctl "mute" "dwmblocks"
        ;;
    3)
        right_handler
        ;;
esac
