#!/usr/bin/env bash
# Waybar custom module script for toggling and displaying wlsunset (night light) gamma adjustment service state.
# Usage:
#   nightlight.sh            # outputs JSON status for Waybar
#   nightlight.sh toggle     # toggles service start/stop then outputs status
#
# Relies on the user systemd unit "wlsunset.service" defined in Home Manager.
# The unit is intentionally not enabled (no WantedBy) so it only runs when toggled.

ICON_ON=""
ICON_OFF=""
SERVICE="wlsunset.service"

get_state() {
    if systemctl --user is-active --quiet "$SERVICE"; then
        echo "active"
    else
        echo "inactive"
    fi
}

toggle() {
    if [ "$(get_state)" = "active" ]; then
        systemctl --user stop "$SERVICE" >/dev/null 2>&1
    else
        systemctl --user start "$SERVICE" >/dev/null 2>&1
    fi
}

output_json() {
    state=$(get_state)
    if [ "$state" = "active" ]; then
        text="$ICON_ON"
        tooltip="Turn off night light"
    else
        text="$ICON_OFF"
        tooltip="Turn on night light"
    fi
    printf '{"text":"%s","tooltip":"%s","alt":"%s"}' "$text" "$tooltip" "$state"
}

case "$1" in
toggle)
    toggle
    output_json
    ;;
*)
    output_json
    ;;
esac
