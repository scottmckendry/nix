#!/usr/bin/env bash

# Power menu using vicinae dmenu

declare -A menu=(
    ["󰍃  Logout"]="niri msg action quit"
    ["  Reboot"]="reboot"
    ["󰤄  Suspend"]="systemctl suspend"
    ["⏻  Shutdown"]="shutdown now"
    ["󰜗  Hibernate"]="systemctl hibernate"
    ["  Lock"]="hyprlock"
)

selected=$(printf '%s\n' "${!menu[@]}" | vicinae dmenu --placeholder "Select an action...")
if [[ -n "$selected" && -n "${menu[$selected]}" ]]; then
    ${menu[$selected]}
fi
