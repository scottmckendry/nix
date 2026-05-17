#!/usr/bin/env bash
# Waybar custom module for flake auto-update PRs.
# Usage:
#   auto-update.sh           # outputs one JSON status line for Waybar
#   auto-update.sh merge     # merges the ready PR then rebuilds via kitty socket

ICON_READY="󰚰"
ICON_BUILDING="󰔟"
ICON_NONE=""

get_pr() {
    gh pr list \
        --repo scottmckendry/nix \
        --label "nix" \
        --state open \
        --json number,title,labels \
        --limit 1 \
        2>/dev/null | jq -c '.[0] // null'
}

is_cachix_ready() {
    local pr="$1"
    printf '%s' "$pr" | jq -e '[.labels[].name] | contains(["cachix-ready"])' >/dev/null 2>&1
}

output_json() {
    local pr
    pr=$(get_pr)

    if [ "$pr" = "null" ] || [ -z "$pr" ]; then
        printf '{"text":" ","tooltip":"No pending flake updates","alt":"none","class":"none"}\n'
        return
    fi

    local number title
    number=$(printf '%s' "$pr" | jq -r '.number')
    title=$(printf '%s' "$pr" | jq -r '.title')

    if is_cachix_ready "$pr"; then
        printf '{"text":"%s","tooltip":"#%s: %s\\nClick to merge and rebuild","alt":"ready","class":"ready"}\n' \
            "$ICON_READY" "$number" "$title"
    else
        printf '{"text":"%s","tooltip":"#%s: %s\\nBuild in progress...","alt":"building","class":"building"}\n' \
            "$ICON_BUILDING" "$number" "$title"
    fi
}

merge_and_rebuild() {
    local pr
    pr=$(get_pr)

    if [ "$pr" = "null" ] || [ -z "$pr" ]; then
        exit 0
    fi

    if ! is_cachix_ready "$pr"; then
        exit 0
    fi

    local number
    number=$(printf '%s' "$pr" | jq -r '.number')

    if kitten @ --to unix:/tmp/kitty-socket launch --type=tab \
        zsh -c "$HOME/scripts/nixos-update.sh $number; exec zsh" 2>/dev/null; then
        exit 0
    fi
    kitty zsh -c "$HOME/scripts/nixos-update.sh $number; exec zsh"
}

case "$1" in
merge)
    merge_and_rebuild
    ;;
*)
    output_json
    ;;
esac
