#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-switch}"

cd "$HOME/git/nix"
git add -A -N

case "$MODE" in
switch) nh os switch . ;;
boot) nh os boot . ;;
*)
    echo "Usage: rebuild.sh [switch|boot]" >&2
    exit 1
    ;;
esac
