#!/usr/bin/env bash
# NixOS flake update + rebuild helper.
#
#   nix-update status               print the current update state
#   nix-update glyph                write a status glyph to $CACHE
#   nix-update update [switch|boot] merge a ready update PR, pull, rebuild
#   nix-update rebuild [switch|boot] rebuild only
#
# Update states:
#   ready <pr>     open update PR is built and labelled cachix-ready
#   failed <pr>    open update PR failed to build
#   building <pr>  open update PR still building
#   behind         no PR open, and origin/main has commits this checkout lacks
#   current        no PR open, and there is nothing to pull
set -euo pipefail

readonly REPO="${NIX_UPDATE_REPO:-scottmckendry/nix}"
readonly REPO_DIR="${NIX_REPO_DIR:-$HOME/git/nix}"
readonly CACHE="${NIX_UPDATE_CACHE:-$HOME/.cache/nix-update-status}"
readonly SELF="${0##*/}"

usage() {
    cat <<EOF
Usage: $SELF <command>

  status                print the flake update state
  glyph                 write a status glyph for the status bar
  update [switch|boot]  merge a ready update PR, pull, then rebuild
  rebuild [switch|boot] rebuild only

States: ready <pr> | failed <pr> | building <pr> | behind | current
EOF
}

behind_count() {
    local upstream count
    git -C "$REPO_DIR" fetch --quiet origin >/dev/null 2>&1 || true
    upstream=$(git -C "$REPO_DIR" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || echo origin/main)
    count=$(git -C "$REPO_DIR" rev-list --count "HEAD..$upstream" 2>/dev/null || echo 0)
    [[ $count =~ ^[0-9]+$ ]] || count=0
    printf '%s\n' "$count"
}

open_pr_state() {
    local pr_json pr_number labels
    pr_json=$(gh pr list --repo "$REPO" --label nix --state open --json number,labels --limit 1 2>/dev/null || echo "[]")
    [[ $pr_json != "[]" ]] || return 0

    pr_number=$(jq -r '.[0].number' <<<"$pr_json")
    labels=$(jq -r '.[0].labels[].name' <<<"$pr_json" 2>/dev/null || true)

    if grep -qw cachix-ready <<<"$labels"; then
        printf 'ready %s\n' "$pr_number"
    elif grep -qw build-failed <<<"$labels"; then
        printf 'failed %s\n' "$pr_number"
    else
        printf 'building %s\n' "$pr_number"
    fi
}

status() {
    local state
    if state=$(open_pr_state) && [[ -n $state ]]; then
        printf '%s\n' "$state"
    elif (($(behind_count) > 0)); then
        printf 'behind\n'
    else
        printf 'current\n'
    fi
}

glyph() {
    local state glyph=
    state=$(status)
    mkdir -p "$(dirname "$CACHE")"

    case "$state" in
    ready*) glyph='' ;;
    failed*) glyph='' ;;
    building*) glyph='󱤛' ;;
    behind*) glyph='' ;;
    esac

    printf '%s' "$glyph" >"$CACHE"
}

rebuild() {
    [[ $1 =~ ^(switch|boot)$ ]] || {
        echo "Usage: $SELF rebuild [switch|boot]" >&2
        return 1
    }

    cd "$REPO_DIR"
    git add -A -N
    nh os "$1" .
}

update() {
    local state pr
    read -r state pr <<<"$(status)"

    case "$state" in
    ready)
        echo "==> Merging PR #$pr..."
        gh pr merge "$pr" --repo "$REPO" --rebase --delete-branch
        ;;
    failed)
        echo "✗ PR #$pr failed to build" >&2
        return 1
        ;;
    building)
        echo "⏳ PR #$pr still building"
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
    rebuild "$1"
}

cmd="${1:-}"

if [[ -z $cmd ]]; then
    usage >&2
    exit 1
fi

case "$cmd" in
status) status ;;
glyph) glyph ;;
update | rebuild) "$cmd" "${2:-switch}" ;;
-h | --help | help) usage ;;
*)
    usage >&2
    exit 1
    ;;
esac
