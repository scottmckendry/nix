#!/usr/bin/env bash
# Lock and keep turning off monitors while still locked.
# Re-sleeps displays periodically in case of user activity while locked.

set -euo pipefail

INITIAL_DELAY="${1:-5}"   # seconds before first power-off
CHECK_INTERVAL="${2:-10}" # seconds between checks while locked

# Background watchdog: while hyprlock runs, keep powering off monitors.
nohup setsid bash -c "
  sleep \"$INITIAL_DELAY\"
  while pgrep -x hyprlock >/dev/null 2>&1; do
    niri msg action power-off-monitors >/dev/null 2>&1 || true

    # Wait before checking again.
    sleep \"$CHECK_INTERVAL\"
  done
" >/dev/null 2>&1 &

# Start hyprlock in the foreground.
exec hyprlock --grace 5
