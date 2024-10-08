#!/usr/bin/env bash

CONFIG_FILES="$HOME/.config/waybar/config.jsonc $HOME/.config/waybar/style.css"

trap "killall waybar" EXIT
while true; do
    waybar &
    inotifywait -e modify $CONFIG_FILES
    killall .waybar-wrapped
done
