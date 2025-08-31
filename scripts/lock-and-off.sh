#!/usr/bin/env bash
# Lock the session, then power off monitors shortly after.
# Works around hyprlock being blocking by detaching the power-off step.

set -euo pipefail

DELAY_SECONDS="${1:-10}"

# Kick off a detached background task that waits, then powers off monitors.
# Using setsid+nohup ensures it outlives the keybinding launcher.
nohup setsid bash -c "
  sleep \"$DELAY_SECONDS\"
  niri msg action power-off-monitors >/dev/null 2>&1
" >/dev/null 2>&1 &

# Now run the lock (blocking is fine here; background task will handle displays)
exec hyprlock
