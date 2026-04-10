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
# Calling the same preset a second time returns to the default geo schedule.

ICON_ON=""
ICON_OFF=""

get_status() {
	sunsetr status --json 2>/dev/null
}

# Returns "on" when the display is showing a warm/night-light effect, either
# because geo says it's night, or because the night preset is overriding day.
get_state() {
	local status
	status=$(get_status) || {
		echo "inactive"
		return
	}

	local preset period
	preset=$(printf '%s' "$status" | jq -r '.active_preset // "default"')
	period=$(printf '%s' "$status" | jq -r '.period // "day"')

	if [ "$preset" = "night" ]; then
		echo "on"
	elif [ "$preset" = "day" ]; then
		echo "off"
	else
		# default geo schedule — on during night/sunset, off during day/sunrise
		case "$period" in
		night | sunset) echo "on" ;;
		*) echo "off" ;;
		esac
	fi
}

toggle() {
	local status
	status=$(get_status) || return

	local preset period
	preset=$(printf '%s' "$status" | jq -r '.active_preset // "default"')
	period=$(printf '%s' "$status" | jq -r '.period // "day"')

	if [ "$preset" != "default" ]; then
		# Already overriding — call same preset again to toggle back to default
		sunsetr preset "$preset" >/dev/null 2>&1
	else
		# On default geo schedule — apply the opposite-of-current preset
		case "$period" in
		night | sunset) sunsetr preset day >/dev/null 2>&1 ;;
		*) sunsetr preset night >/dev/null 2>&1 ;;
		esac
	fi
}

format_json() {
	local preset="$1" period="$2"
	local state text tooltip

	if [ "$preset" = "night" ]; then
		state="on"
	elif [ "$preset" = "day" ]; then
		state="off"
	else
		case "$period" in
		night | sunset) state="on" ;;
		*) state="off" ;;
		esac
	fi

	if [ "$state" = "on" ]; then
		text="$ICON_ON"
		tooltip="Night light on — click to disable"
	else
		text="$ICON_OFF"
		tooltip="Night light off — click to enable"
	fi

	printf '{"text":"%s","tooltip":"%s","alt":"%s"}\n' "$text" "$tooltip" "$state"
}

output_json() {
	local status
	status=$(get_status) || {
		format_json "default" "day"
		return
	}
	local preset period
	preset=$(printf '%s' "$status" | jq -r '.active_preset // "default"')
	period=$(printf '%s' "$status" | jq -r '.period // "day"')
	format_json "$preset" "$period"
}

# Stream updates from sunsetr IPC — emits a new waybar JSON line on every
# relevant event so the icon reacts instantly without polling.
watch() {
	# Emit current state immediately so waybar has something to show on start
	output_json

	sunsetr status --json --follow 2>/dev/null | while IFS= read -r line; do
		event=$(printf '%s' "$line" | jq -r '.event_type // ""')
		case "$event" in
		state_applied)
			preset=$(printf '%s' "$line" | jq -r '.active_preset // "default"')
			period=$(printf '%s' "$line" | jq -r '.period // "day"')
			format_json "$preset" "$period"
			;;
		preset_changed)
			preset=$(printf '%s' "$line" | jq -r '.to_preset // "default"')
			period=$(printf '%s' "$line" | jq -r '.target_period // "day"')
			format_json "$preset" "$period"
			;;
		esac
	done
}

case "$1" in
toggle)
	toggle
	output_json
	;;
watch)
	watch
	;;
*)
	output_json
	;;
esac
