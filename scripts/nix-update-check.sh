#!/usr/bin/env bash
# Writes nix update status icon to cache for starship prompt.
# Runs as systemd user timer every 5 minutes.

set -euo pipefail

CACHE="$HOME/.cache/nix-update-status"
REPO="scottmckendry/nix"

mkdir -p "$(dirname "$CACHE")"

pr_json=$(gh pr list --repo "$REPO" --label nix --state open \
    --json number,labels --limit 1 2>/dev/null || echo "[]")

if [ "$pr_json" != "[]" ]; then
    labels=$(echo "$pr_json" | jq -r '.[0].labels[].name' 2>/dev/null || true)
    if echo "$labels" | grep -qw "cachix-ready"; then
        echo "" >"$CACHE"
    elif echo "$labels" | grep -qw "build-failed"; then
        echo "" >"$CACHE"
    else
        echo "󱤛" >"$CACHE"
    fi
else
    local=$(git -C "$HOME/git/nix" rev-parse HEAD 2>/dev/null || echo "")
    remote=$(gh api "repos/$REPO/git/ref/heads/main" \
        --jq .object.sha 2>/dev/null || echo "")
    if [ -n "$local" ] && [ -n "$remote" ] && [ "$local" != "$remote" ]; then
        echo "↓" >"$CACHE"
    else
        : >"$CACHE"
    fi
fi
