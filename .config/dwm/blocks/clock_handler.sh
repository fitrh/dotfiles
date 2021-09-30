#!/usr/bin/env bash

left_handler() {
    local DAY DATE MONTH YEAR TIMEZONE
    sigdwmblocks 1
    DAY="<span foreground='#7da6ff'>$(date +'%a')</span>"
    MONTH="$(date +'%b')"
    DATE="<span foreground='#7da6ff'>$(date +'%-d')</span>"
    YEAR="$(date +'%Y')"
    TIMEZONE="$(date +'%Z')"
    dunstify -a "dwmblocks clock handler" \
        -h string:x-dunst-stack-tag:dwmblocks \
        "$(date +'%H:%M %p')" "$DAY, $MONTH $DATE $YEAR ($TIMEZONE)"
}

middle_handler() {
    sigdwmblocks 1
    exec st -c "Notify Term" \
        -f "SF Mono:size=8" \
        -T "The Priceless Thing" \
        -g 56x11 \
        -e tty-clock -C 1 -sxcbBf '%A, %B %d %Y'
}

right_handler() {
    sigdwmblocks 1
    exec st -c "Notify Term" \
        -f "SF Mono:size=8.4" \
        -g 64x24 \
        -e calcurse
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
