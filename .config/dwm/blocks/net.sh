#!/usr/bin/env bash

notify_net_speed() {
    sigdwmblocks 7 "$1"
}

get_op_state() {
    printf "%s" "$(<"/sys/class/net/$1/operstate")"
}

# TODO: detect limited network
get_carrier_changes() {
    # ODD  : limited connection -- WRONG !!!
    # EVEN : full connection
    printf "%s" "$(<"/sys/class/net/$1/carrier_changes")"
}

is_fully_connected() {
    return $(( "$1" % 2 ))
}

net_wired_state() {
    local COLOR="\x13"
    local ICON=""
    local SIGVAL=-1

    if is_fully_connected "$(get_carrier_changes enp3s0)"; then
        COLOR="\x17"
        ICON=""
        SIGVAL=0
    fi

    notify_net_speed "$SIGVAL"
    printf "%b %s " "$COLOR"  "$ICON"
}

net_wireless_get_strength() {
    local FILE LAST_LINE VALUES QUALITY_LINK
    mapfile -tn 0 FILE < "/proc/net/wireless"
    LAST_LINE="$(printf "%s" "${FILE[@]: -1}")"
    read -ra VALUES <<< "${LAST_LINE[@]}"
    QUALITY_LINK="$(printf "%d" "${VALUES[2]//.}")"
    printf "%d" $(( QUALITY_LINK * 100 / 70 ))
}

net_wireless_get_icon() {
    local ICON="󰤯"
    [[ "$1" -ge 30 ]] && ICON="󰤟"
    [[ "$1" -ge 50 ]] && ICON="󰤢"
    [[ "$1" -ge 70 ]] && ICON="󰤥"
    [[ "$1" -ge 90 ]] && ICON="󰤨"
    printf "%s" "$ICON"
}

net_wireless_state() {
    local COLOR="\x13"
    local ICON="󰤫"
    local SIGVAL=-1

    if is_fully_connected "$(get_carrier_changes wlp2s0)"; then
        COLOR="\x17"
        STRENGTH="$(net_wireless_get_strength)"
        ICON="$(net_wireless_get_icon "$STRENGTH")"
        SIGVAL=1
    fi

    notify_net_speed "$SIGVAL"
    printf "%b %s " "$COLOR"  "$ICON"
}

netb() {
    local STATE="\x15   "

    if [[ "$(get_op_state enp3s0)" == "up" ]]; then
        STATE="$(net_wired_state)"
    elif [[ "$(get_op_state wlp2s0)" == "up" ]]; then
        STATE="$(net_wireless_state)"
    else
        notify_net_speed -1
    fi

    printf "%b\x0b" "$STATE"
}

parse_terse() {
    printf "%s" "$1" | cut -d ":" -f "$2"
}

net() {
    local GENERAL STATE TYPE CONNECTIVITY STRENGTH
    local ICON=" "
    local COLOR="\x15"

    # TODO: Replace nmcli with handcraft function
    GENERAL=$(nmcli -f STATE,CONNECTIVITY -t general)

    STATE="$(parse_terse "$GENERAL" 1)"
    [[ "$STATE" == "disconnected" ]] && sigdwmblocks 7
    [[ "$STATE" =~ "connected" ]] && [[  "$STATE" != "disconnected" ]] && {
        CONNECTIVITY="$(parse_terse "$GENERAL" 2)"
        TYPE=$(nmcli -f TYPE -t connection show --active)

        if [[ "$CONNECTIVITY" != "full" ]]; then
            sigdwmblocks 7
            COLOR="\x13"
            ICON=""
            [[ "$TYPE" =~ "wireless" ]] && ICON="󰤫"
        else
            COLOR="\x17"
            if [[ "$TYPE" =~ "wireless" ]]; then
                sigdwmblocks 7 1
                STRENGTH="$(net_wireless_get_strength)"
                ICON="$(net_wireless_get_icon "$STRENGTH")"
            else
                sigdwmblocks 7 0
                ICON=""
            fi
        fi
    }

    printf " $COLOR%s\x0b " "$ICON"
}

netb "$@"
