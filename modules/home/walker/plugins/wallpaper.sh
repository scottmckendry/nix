#!/usr/bin/env bash

# Walker plugin: wallpaper
# Lists wallpapers and sets the selected one as the current wallpaper. This is applied to swaybg & swaylock.

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="/tmp/current_wallpaper"

info() {
    echo 'placeholder = "Select a wallpaper"'
    echo 'name = "wallpaper"'
    echo 'switcher_only = true'
    echo 'parser = "kv"'
}

entries() {
    Sel=$(find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \))
    while IFS= read -r path; do
        label="${path##*/}"
        exec="ln -sf \"$path\" \"$CACHE_FILE\" && niri msg action do-screen-transition --delay-ms 400 && systemctl --user restart swaybg.service"
        echo "label=$label;exec=$exec;image=$path;recalculate_score=true;value=$path"
    done <<<"$Sel"
}

case "$1" in
info)
    info
    ;;
entries)
    entries
    ;;
*)
    echo "Usage: $0 {info|entries}"
    exit 1
    ;;
esac
