#!/usr/bin/env bash

lock() {
    local STATE
    local CAPS_STATE="בּ"
    local NUM_STATE=""

    [[ $(xset -q | rg "Caps Lock: *on") ]] && STATE+="$CAPS_STATE"
    [[ $(xset -q | rg "Num Lock: *on") ]] && STATE+="$NUM_STATE"
    [[ "$STATE" == "$CAPS_STATE$NUM_STATE" ]] && STATE="$CAPS_STATE $NUM_STATE"
    [[ -n "$STATE" ]] && printf "\x0e %s \x0b" "$STATE"
}

lock
