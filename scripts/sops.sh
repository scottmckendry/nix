#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
WORKSPACE="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/sops-workspace/nix"

load_age_key() {
    local key
    key="$(secret-tool lookup app sops type age-key 2>/dev/null)"
    if [ -z "$key" ]; then
        echo "Error: age key not found in keyring. Store it with:" >&2
        echo "  secret-tool store --label=\"age secret key\" app sops type age-key" >&2
        exit 1
    fi
    export SOPS_AGE_KEY="$key"
}

ensure_workspace() {
    mkdir -p "$WORKSPACE"
    chmod 700 "$WORKSPACE"
}

usage() {
    cat <<EOF
Usage: $(basename "$0") <command>

Commands:
    decrypt     Decrypt all *.secret.sops.yaml files into workspace (tmpfs)
    encrypt     Encrypt *.secret.yaml files from workspace back to repo

Workspace: $WORKSPACE (tmpfs — cleared on reboot)
EOF
    exit 1
}

[ $# -ne 1 ] && usage

CMD="$1"

load_age_key
ensure_workspace

case "$CMD" in
decrypt)
    find "$REPO_ROOT" -type f -name "*.secret.sops.yaml" | while read -r file; do
        rel="${file#$REPO_ROOT/}"
        dest="$WORKSPACE/${rel/.secret.sops.yaml/.secret.yaml}"
        mkdir -p "$(dirname "$dest")"
        chmod 700 "$(dirname "$dest")"
        echo "  Decrypting $rel"
        sops --decrypt "$file" >"$dest"
        chmod 600 "$dest"
        link="$REPO_ROOT/${rel/.secret.sops.yaml/.secret.yaml}"
        ln -sf "$dest" "$link"
    done
    echo "Workspace: $WORKSPACE"
    ;;
encrypt)
    find "$WORKSPACE" -type f -name "*.secret.yaml" | while read -r file; do
        rel="${file#$WORKSPACE/}"
        dest="$REPO_ROOT/${rel/.secret.yaml/.secret.sops.yaml}"
        if [ ! -f "$dest" ] || ! sops --decrypt "$dest" 2>/dev/null | diff - "$file" >/dev/null 2>&1; then
            echo "  Encrypting $rel"
            mkdir -p "$(dirname "$dest")"
            sops --encrypt "$file" >"$dest"
        else
            echo "  No changes: $rel"
        fi
        plain_link="$REPO_ROOT/$rel"
        [ -L "$plain_link" ] && rm -f "$plain_link"
    done
    ;;
*)
    usage
    ;;
esac
