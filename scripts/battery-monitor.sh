#!/usr/bin/env bash

# Send notification when battery reches critical level. Run as a service that executes every 30 seconds.

show_usage() {
    echo "Usage: $0 [-h]"
    echo "  -h    Show this help message"
    echo "This script sends a notification when battery is critically low."
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_usage
    exit 0
fi

BATTERY_THRESHOLD=5
NOTIFICATION_FLAG="/tmp/battery_notified"

get_battery_percentage() {
    upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | grep -o '[0-9]\+%' | sed 's/%//'
}

get_battery_state() {
    upower -i $(upower -e | grep 'BAT') | grep -E "state" | awk '{print $2}'
}

send_notification() {
    notify-send -u critical "󱐋 Time to recharge!" "Battery is down to ${1}%" -i battery-caution -t 30000
}

BATTERY_LEVEL=$(get_battery_percentage)
BATTERY_STATE=$(get_battery_state)

if [[ "$BATTERY_STATE" == "discharging" && "$BATTERY_LEVEL" -le "$BATTERY_THRESHOLD" ]]; then
    if [[ ! -f "$NOTIFICATION_FLAG" ]]; then
        send_notification "$BATTERY_LEVEL"
        touch "$NOTIFICATION_FLAG"
    fi
else
    rm -f "$NOTIFICATION_FLAG"
fi
