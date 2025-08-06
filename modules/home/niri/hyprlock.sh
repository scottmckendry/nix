#!/usr/bin/env bash
# Login wrapper for hyprlock. Since calling hyprlock directly on startup seems to fail consistently.
# ¯\_(ツ)_/¯

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

# HACK: automatically close the focussed window right after unlocking
# This window happens to be the Gnome Keyring unlock dialog which
# is (after unlocking with hyprlock) redundant. For this reason, this
# script should only be run at login, not for normal locking/idle.
niri msg action close-window

exit $STATUS
