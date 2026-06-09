#!/usr/bin/env bash
# Waybar custom module for sunsetr night-light toggle.
# Usage:
#   nightlight.sh            # outputs one JSON status line for Waybar
#   nightlight.sh toggle     # toggles night-light override then outputs status
#   nightlight.sh watch      # streams JSON lines reactively via sunsetr IPC
#
# Normal operation: sunsetr runs geo/time-based transitions automatically.
# This toggle applies a static preset override in the "wrong" direction:
#   - During day   → force night preset (warm/dim)
#   - During night → force day preset   (neutral/bright)
#   - During transition → force day preset (skip ahead)
# Calling the same preset a second time returns to the default geo schedule.

ICON_ON=""
ICON_OFF=""
ICON_TRANSITIONING="󰔎"

get_status() {
    sunsetr status --json 2>/dev/null
}

# Returns the current display state: "on", "off", or "transitioning".
get_state() {
    local status
    status=$(get_status) || {
        echo "off"
        return
    }

    local preset period state
    preset=$(printf '%s' "$status" | jq -r '.active_preset // "default"')
    period=$(printf '%s' "$status" | jq -r '.period // "day"')
    state=$(printf '%s' "$status" | jq -r '.state // "stable"')

    if [ "$preset" = "night" ]; then
        echo "on"
    elif [ "$preset" = "day" ]; then
        echo "off"
    elif [ "$state" = "transitioning" ]; then
        echo "transitioning"
    else
        case "$period" in
        night | sunset) echo "on" ;;
        *) echo "off" ;;
        esac
    fi
}

toggle() {
    local status
    status=$(get_status) || return

    local preset
    preset=$(printf '%s' "$status" | jq -r '.active_preset // "default"')

    if [ "$preset" != "default" ]; then
        # Already overriding — call same preset again to return to geo schedule
        sunsetr preset "$preset" >/dev/null 2>&1
    else
        # No override — determine what display currently looks like, apply opposite
        case "$(get_state)" in
        on | transitioning) sunsetr preset day >/dev/null 2>&1 ;;
        off) sunsetr preset night >/dev/null 2>&1 ;;
        esac
    fi
}

format_json() {
    local state
    state=$(get_state)
    local text tooltip

    case "$state" in
    on)
        text="$ICON_ON"
        tooltip="Night light on — click to disable"
        ;;
    transitioning)
        text="$ICON_TRANSITIONING"
        tooltip="Night light transitioning to day — click to skip"
        ;;
    *)
        text="$ICON_OFF"
        tooltip="Night light off — click to enable"
        ;;
    esac

    printf '{"text":"%s","tooltip":"%s","alt":"%s"}\n' "$text" "$tooltip" "$state"
}

# Stream updates from sunsetr IPC — emits a new waybar JSON line on every
# relevant event so the icon reacts instantly without polling.
watch() {
    format_json

    sunsetr status --json --follow 2>/dev/null | while IFS= read -r line; do
        event=$(printf '%s' "$line" | jq -r '.event_type // ""')
        case "$event" in
        state_applied | preset_changed)
            format_json
            ;;
        esac
    done
}

case "$1" in
toggle)
    toggle
    sleep 0.1
    format_json
    ;;
watch)
    watch
    ;;
*)
    format_json
    ;;
esac
