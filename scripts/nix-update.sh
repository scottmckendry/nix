#!/usr/bin/env bash
# NixOS flake update + rebuild helper.
#
#   nix-update.sh status               print the current update state
#   nix-update.sh glyph                write a status glyph to $CACHE
#   nix-update.sh update [switch|boot] merge a ready update PR, pull, rebuild
#   nix-update.sh rebuild [switch|boot] rebuild only
#
# Update states:
#   ready <pr>     open update PR is built and labelled cachix-ready
#   failed <pr>    open update PR failed to build
#   building <pr>  open update PR still building
#   behind         no PR open, and origin/main has commits this checkout lacks
#   current        no PR open, and there is nothing to pull
set -euo pipefail

REPO="${NIX_UPDATE_REPO:-scottmckendry/nix}"
REPO_DIR="${NIX_REPO_DIR:-$HOME/git/nix}"
CACHE="${NIX_UPDATE_CACHE:-$HOME/.cache/nix-update-status}"

usage() {
    cat <<EOF
Usage: $(basename "$0") <command>

  status               print the flake update state
  glyph                write a status glyph for the status bar
  update [switch|boot] merge a ready update PR, pull, then rebuild
  rebuild [switch|boot] rebuild only

States: ready <pr> | failed <pr> | building <pr> | behind | current
EOF
}

# Number of commits on origin/main that the local checkout does not have. A
# local branch that is ahead of origin contributes 0, so this only counts work
# that is actually waiting to be pulled.
behind_count() {
    local up n
    git -C "$REPO_DIR" fetch --quiet origin >/dev/null 2>&1 || true
    up=$(git -C "$REPO_DIR" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || echo origin/main)
    n=$(git -C "$REPO_DIR" rev-list --count "HEAD..$up" 2>/dev/null || echo 0)
    [[ $n =~ ^[0-9]+$ ]] || n=0
    echo "$n"
}

status() {
    local pr_json
    pr_json=$(gh pr list --repo "$REPO" --label nix --state open \
        --json number,labels --limit 1 2>/dev/null || echo "[]")

    if [ "$pr_json" != "[]" ]; then
        local num labels
        num=$(jq -r '.[0].number' <<<"$pr_json")
        labels=$(jq -r '.[0].labels[].name' <<<"$pr_json" 2>/dev/null || true)
        if grep -qw cachix-ready <<<"$labels"; then
            echo "ready $num"
        elif grep -qw build-failed <<<"$labels"; then
            echo "failed $num"
        else
            echo "building $num"
        fi
        return
    fi

    if [ "$(behind_count)" -gt 0 ]; then
        echo "behind"
    else
        echo "current"
    fi
}

glyph() {
    local state
    state=$(status)
    mkdir -p "$(dirname "$CACHE")"

    case "$state" in
    ready*) printf '%s' '' >"$CACHE" ;;
    failed*) printf '%s' '' >"$CACHE" ;;
    building*) printf '%s' '󱤛' >"$CACHE" ;;
    behind*) printf '%s' '' >"$CACHE" ;;
    *) : >"$CACHE" ;;
    esac
}

rebuild() {
    local mode="${1:-switch}"
    case "$mode" in
    switch | boot) ;;
    *)
        echo "Usage: $(basename "$0") rebuild [switch|boot]" >&2
        return 1
        ;;
    esac
    cd "$REPO_DIR"
    git add -A -N
    nh os "$mode" .
}

update() {
    local mode="${1:-switch}"
    local state
    state=$(status)

    case "$state" in
    "ready "*)
        local num="${state#ready }"
        echo "==> Merging PR #$num..."
        gh pr merge "$num" --repo "$REPO" --rebase --delete-branch
        ;;
    "failed "*)
        echo "✗ PR #${state#failed } failed to build" >&2
        return 1
        ;;
    "building "*)
        echo "⏳ PR #${state#building } still building"
        return 0
        ;;
    current)
        echo "✓ Up to date"
        return 0
        ;;
    behind) ;; # no PR open, fall through to pull and rebuild
    *)
        echo "Unexpected state: $state" >&2
        return 1
        ;;
    esac

    echo "==> Pulling latest..."
    git -C "$REPO_DIR" pull --ff-only
    rebuild "$mode"
}

case "${1:-update}" in
status) status ;;
glyph) glyph ;;
update) update "${2:-switch}" ;;
rebuild) rebuild "${2:-switch}" ;;
-h | --help | help) usage ;;
*)
    usage >&2
    exit 1
    ;;
esac
