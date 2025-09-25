#!/usr/bin/env bash
# Waybar custom module script for toggling and displaying WireGuard "Home" connection state.
# Usage:
#   wireguard.sh            # outputs JSON status for Waybar
#   wireguard.sh toggle     # toggles connection up/down then outputs status
#   wireguard.sh exists     # exits 0 if connection exists, else 1 (for Waybar module visibility)

CONN_NAME="Home"
ICON_ON=""
ICON_OFF=""

get_state() {
    # nmcli returns 'activated' for active connections in `-t -f NAME,TYPE,DEVICE connection show --active`
    if nmcli -t -f NAME connection show --active | grep -qx "$CONN_NAME"; then
        echo "up"
    else
        echo "down"
    fi
}

toggle() {
    if [ "$(get_state)" = "up" ]; then
        nmcli connection down "$CONN_NAME" >/dev/null 2>&1
    else
        nmcli connection up "$CONN_NAME" >/dev/null 2>&1
    fi
}

output_json() {
    state=$(get_state)
    if [ "$state" = "up" ]; then
        text="$ICON_ON"
        tooltip="WireGuard $CONN_NAME: connected"
    else
        text="$ICON_OFF"
        tooltip="WireGuard $CONN_NAME: disconnected"
    fi
    printf '{"text":"%s","tooltip":"%s","alt":"%s"}' "$text" "$tooltip" "$state"
}

if [ "$1" = "exists" ]; then
    # Exit 0 if the named WireGuard connection exists, else 1
    nmcli -t -f NAME connection show | grep -qx "$CONN_NAME"
elif [ "$1" = "toggle" ]; then
    toggle
    output_json
else
    output_json
fi
