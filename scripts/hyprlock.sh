#!/usr/bin/env bash

# Login wrapper for hyprlock. Since calling hyprlock directly on startup seems to fail consistently.
# ¯\_(ツ)_/¯

show_usage() {
    echo "Usage: $0 [-h] [hyprlock args...]"
    echo "  -h    Show this help message"
    echo "This is a wrapper for hyprlock that logs output and notifies on failure."
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_usage
    exit 0
fi

LOGFILE="$HOME/.cache/hyprlock.log"
mkdir -p "$(dirname "$LOGFILE")"

echo "\n--- $(date) ---" >"$LOGFILE"
echo "Starting hyprlock..." >>"$LOGFILE"

# Run hyprlock, log stdout and stderr
hyprlock "$@" >>"$LOGFILE" 2>&1
STATUS=$?

if [ $STATUS -ne 0 ]; then
    notify-send "Hyprlock failed :(" "Exit code: $STATUS. See $LOGFILE"
fi

niri msg action close-window

exit $STATUS
