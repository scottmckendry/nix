#!/usr/bin/env bash
# Check for nix updates and apply.
set -euo pipefail

REPO="scottmckendry/nix"

pr_json=$(gh pr list --repo "$REPO" --label nix --state open \
    --json number,labels --limit 1 2>/dev/null || echo "[]")

if [ "$pr_json" != "[]" ]; then
    num=$(echo "$pr_json" | jq -r '.[0].number')
    labels=$(echo "$pr_json" | jq -r '.[0].labels[].name' 2>/dev/null || true)
    if echo "$labels" | grep -qw "cachix-ready"; then
        echo "==> Merging PR #$num..."
        gh pr merge "$num" --repo "$REPO" --rebase --delete-branch
    else
        echo "⏳ PR #$num building"
        exit 0
    fi
else
    local=$(git -C "$HOME/git/nix" rev-parse HEAD 2>/dev/null || echo "")
    remote=$(gh api "repos/$REPO/git/ref/heads/main" \
        --jq .object.sha 2>/dev/null || echo "")
    if [ -n "$local" ] && [ -n "$remote" ] && [ "$local" != "$remote" ]; then
        : # behind, fall through to rebuild
    else
        echo "✓ Up to date"
        exit 0
    fi
fi

echo "==> Pulling latest..."
cd "$HOME/git/nix"
git pull

echo "==> Rebuilding..."
"$HOME/scripts/rebuild.sh" switch
