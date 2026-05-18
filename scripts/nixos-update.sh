#!/usr/bin/env bash
# Merges the pending flake update PR and rebuilds the system.
# Intended to be launched in a kitty tab via auto-update.sh.

PR_NUMBER="$1"

if [ -n "$PR_NUMBER" ]; then
    echo "==> Merging PR #$PR_NUMBER..."
    gh pr merge "$PR_NUMBER" \
        --repo scottmckendry/nix \
        --rebase \
        --delete-branch
fi

echo "==> Pulling latest..."
cd "$HOME/git/nix"
git pull

echo "==> Rebuilding..."
"$HOME/scripts/rebuild.sh" switch

echo "==> Done."
