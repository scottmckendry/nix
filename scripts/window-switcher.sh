#!/usr/bin/env bash
# Niri window switcher
# Requires: jq, walker

normalise_app() {
    local app="$1"
    [[ -z "$app" ]] && app="?"

    # strip common prefixes
    app="${app#org.}"
    app="${app#com.}"

    # replace dots with spaces
    app="${app//./ }"
    printf '%s' "$app"
}

niri msg --json windows |
    jq -r '.[] | [(.app_id // ""), (.title // ""), (.id | tostring)] | @tsv' |
    while IFS=$'\t' read -r app title id; do
        [[ -z "$id" ]] && continue
        app="$(normalise_app "$app")"
        printf '%s\t%s\n' "$app • $title" "$id"
    done |
    walker -d -t $'\t' -l 1 -V 2 -p "Select a window to jump to..." |
    xargs -r niri msg action focus-window --id
