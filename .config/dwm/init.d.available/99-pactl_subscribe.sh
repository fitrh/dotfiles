#!/usr/bin/env bash

pactl_subscribe() {
    pactl subscribe |
        while IFS='' read -r output; do
            case "$output" in
                *" sink "*)
                    sigdwmblocks 4
                    ;;
            esac
        done
}

pactl_subscribe &
