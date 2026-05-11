#!/usr/bin/env bash

# Wrapper for hyprlock for niri startup.
# Notifies user if hyprlock fails to start and logs output to a file.
# Closes the gnome keyring prompt window after unlocking. Side-effect of greetd autologin.

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

# hyprlock has unlocked the keyring, so kill prompt window
killall .gcr-prompter-w 2>/dev/null

exit $STATUS
