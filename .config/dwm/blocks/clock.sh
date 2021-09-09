#!/usr/bin/env bash

clock() {
    local CLOCK PERIOD FORMAT
    CLOCK=$(date +"%I:%M")
    PERIOD=$(date +"%p")
    FORMAT="$CLOCK \x18$PERIOD\x0b"
    printf " %b " "$FORMAT"
}

clock
