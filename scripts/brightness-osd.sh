#!/usr/bin/env bash

# Controls brightness using brightnessctl, with OSD notifications via notify-send.

show_usage() {
    echo "Usage: $0 [--inc|--dec|--get|-h]"
    echo "  --inc     Increase brightness by 5%"
    echo "  --dec     Decrease brightness by 5%"
    echo "  --get     Print current brightness"
    echo "  -h        Show this help message"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_usage
    exit 0
fi

# Get the first backlight device (works for most systems)
get_backlight_device() {
    brightnessctl --list | awk -F"'" '/Device/ && /backlight/ {print $2; exit}'
}

# Get current brightness as integer percent
get_brightness() {
    local device
    device=$(get_backlight_device)
    brightnessctl -d "$device" get | awk -v max="$(brightnessctl -d "$device" max)" '{printf "%.0f", ($1/max)*100}'
}

# Get current brightness as pretty string (e.g. "50% (intel_backlight)")
get_brightness_string() {
    local device
    device=$(get_backlight_device)
    local percent
    percent=$(get_brightness)
    echo "$percent% ($device)"
}

# Get Nerd Font icon for current brightness
get_nf_icon() {
    local current
    current=$(get_brightness)
    # Array of icons from lowest to highest
    local icons=(              )
    # Calculate index: 0 (0%) to 14 (100%)
    local idx=$((current * 14 / 100))
    echo "${icons[$idx]}  "
}

# Notify user of brightness
notify_user() {
    local nf_icon
    nf_icon=$(get_nf_icon)
    local brightness_str
    brightness_str=$(get_brightness_string)
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "$nf_icon Brightness" "$brightness_str"
}

# Increase brightness (by 5%)
inc_brightness() {
    local device
    device=$(get_backlight_device)
    brightnessctl -d "$device" set +5%
    notify_user
}

# Decrease brightness (by 5%)
dec_brightness() {
    local device
    device=$(get_backlight_device)
    brightnessctl -d "$device" set 5%-
    notify_user
}

# Main
case "$1" in
--get)
    get_brightness
    ;;
--inc)
    inc_brightness
    ;;
--dec)
    dec_brightness
    ;;
*)
    show_usage
    exit 1
    ;;
esac
