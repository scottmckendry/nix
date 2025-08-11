#!/usr/bin/env bash

# Controls volume using wpctl, with OSD notifications via notify-send.

show_usage() {
    echo "Usage: $0 [--inc|--dec|--toggle|--get|-h]"
    echo "  --inc     Increase volume by 2%"
    echo "  --dec     Decrease volume by 2%"
    echo "  --mute    Toggle mute"
    echo "  --get     Print current volume"
    echo "  -h        Show this help message"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_usage
    exit 0
fi

# Convert float string (e.g. 0.45, 1.00, 1.20) to integer percent (e.g. 45, 100, 120)
float_to_percent() {
    local floatval="$1"
    local percent
    percent=$(printf '%.0f' "$(echo "$floatval * 100" | bc -l 2>/dev/null || awk "BEGIN {print $floatval * 100}")")
    echo "$percent"
}

# Get volume as integer percent (0-100+)
get_volume() {
    local vol_line
    vol_line=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    local vol_float
    vol_float=$(echo "$vol_line" | awk '{print $2}')
    float_to_percent "$vol_float"
}

# Get mute status (true/false)
get_mute() {
    local vol_line
    vol_line=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    if echo "$vol_line" | grep -q '\[MUTED\]'; then
        echo "true"
    else
        echo "false"
    fi
}

# Get Nerd Font icon for current volume state
get_nf_icon() {
    local current=$(get_volume)
    local muted=$(get_mute)
    if [[ "$current" -le 20 || "$muted" == "true" ]]; then
        echo "  "
    elif [[ "$current" -le 50 ]]; then
        echo "  "
    else
        echo "  "
    fi
}

# Get current default output device name
get_output_name() {
    wpctl status | awk '
    $0 ~ /Sinks:/ { in_sinks=1; next }
    in_sinks && /^\s*│/ {
      if ($0 ~ /\*/) {
        sub(/.*\*\s*[0-9]+\.\s*/, "", $0)
        sub(/\s*\[vol:.*$/, "", $0)
        print $0
        exit
      }
    }
    in_sinks && !/^\s*│/ { in_sinks=0 }
  '
}

# Notify user of volume (heading/body)
notify_user() {
    local nf_icon=$(get_nf_icon)
    local current=$(get_volume)
    local muted=$(get_mute)
    local output_name=$(get_output_name)
    if [[ "$muted" == "true" ]]; then
        notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "$nf_icon Volume Muted" "$output_name"
    else
        notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "$nf_icon Volume $current%" "$output_name"
    fi
}

# Increase Volume (clamped to 100%)
inc_volume() {
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+
    local current=$(get_volume)
    if [ "$current" -gt 100 ]; then
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%
    fi
    notify_user
}

# Decrease Volume
dec_volume() {
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%- && notify_user
}

# Toggle Mute
toggle_mute() {
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify_user
}

# Main
case "$1" in
--get)
    get_volume
    ;;
--inc)
    inc_volume
    ;;
--dec)
    dec_volume
    ;;
--mute)
    toggle_mute
    ;;
-h | --help)
    show_usage
    ;;
*)
    show_usage
    exit 1
    ;;
esac
