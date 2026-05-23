#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
SECRETS_DIR="$REPO_ROOT/secrets"
SECRETS_FILE="$SECRETS_DIR/secrets.sops.yaml"
WORKSPACE="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/sops-workspace/nix"

usage() {
    cat <<EOF
Usage: $(basename "$0") <command>

Commands:
    decrypt     Decrypt secrets.sops.yaml → tmpfs workspace, symlink into secrets/
    encrypt     Encrypt secrets/<name>.<ext> symlinks back into secrets.sops.yaml
    clean       Remove tmpfs workspace and symlinks from secrets/

Convention: key names ending in _md, _txt, _yaml determine the file extension.
Workspace: $WORKSPACE (tmpfs — cleared on reboot)
EOF
    exit 1
}

ext_for_key() {
    local key="$1"
    case "$key" in
    *_md) echo "md" ;;
    *_yaml) echo "yaml" ;;
    *) echo "txt" ;;
    esac
}

decrypt() {
    local plain_file
    local key
    local ext
    local filename
    local ws_path
    local link_path

    echo "==> Decrypting $SECRETS_FILE"
    plain_file="$(mktemp "$WORKSPACE/sops-decrypt-XXXXXX.yaml")"
    sops --decrypt "$SECRETS_FILE" >"$plain_file"

    while IFS= read -r key; do
        [ -z "$key" ] && continue

        ext="$(ext_for_key "$key")"
        filename="$key.$ext"
        ws_path="$WORKSPACE/$filename"
        link_path="$SECRETS_DIR/$filename"

        KEY="$key" yq -r '.[strenv(KEY)]' "$plain_file" >"$ws_path"
        chmod 600 "$ws_path"

        if [ -e "$link_path" ] || [ -L "$link_path" ]; then
            rm -f "$link_path"
        fi
        ln -s "$ws_path" "$link_path"
        echo "  - secrets/$filename -> $ws_path"
    done < <(yq -r 'keys | .[]' "$plain_file")

    rm -f "$plain_file"
    echo "✓ Done. Edit files in $WORKSPACE then run: just encrypt"
}

encrypt() {
    local tmpfile
    local outfile
    local path
    local fname
    local key

    echo "==> Building plaintext from secrets/*.md|yaml|txt"
    tmpfile="$WORKSPACE/secrets.plain.sops.yaml"
    printf '{}\n' >"$tmpfile"

    shopt -s nullglob
    for path in "$SECRETS_DIR"/*.{md,yaml,txt}; do
        fname="$(basename "$path")"
        if [[ ! "$fname" =~ ^([a-zA-Z0-9]*_[a-zA-Z0-9_]*)\.(md|yaml|txt)$ ]]; then
            continue
        fi

        key="${BASH_REMATCH[1]}"
        KEY="$key" SRC_PATH="$path" yq -i '.[strenv(KEY)] = load_str(strenv(SRC_PATH))' "$tmpfile"
        echo "  - Reading secrets/$fname"
    done
    shopt -u nullglob
    echo "  - Wrote plaintext $tmpfile"

    outfile="$SECRETS_FILE.out"
    SOPS_AGE_KEY="$SOPS_AGE_KEY" sops --encrypt \
        --config "$REPO_ROOT/.sops.yaml" \
        "$tmpfile" >"$outfile"
    mv "$outfile" "$SECRETS_FILE"
    rm "$tmpfile"
    echo "✓ Encrypted secrets/secrets.sops.yaml"
}

clean() {
    local link

    echo "==> Removing symlinks in $SECRETS_DIR"
    # Remove symlinks from secrets/
    find "$SECRETS_DIR" -maxdepth 1 -type l | while read -r link; do
        rm -f "$link"
        echo "  - Removed symlink $link"
    done

    # Clear workspace
    if [ -d "$WORKSPACE" ]; then
        rm -rf "$WORKSPACE"
        echo "✓ Cleared workspace $WORKSPACE"
    fi
}

[ $# -ne 1 ] && usage

CMD="$1"

key="$(secret-tool lookup app sops type age-key 2>/dev/null)"
if [ -z "$key" ]; then
    echo "Error: age key not found in keyring" >&2
    echo "Store with: secret-tool store --label=\"age secret key\" app sops type age-key" >&2
    exit 1
fi
export SOPS_AGE_KEY="$key"

mkdir -p "$WORKSPACE"
chmod 700 "$WORKSPACE"

command -v yq >/dev/null 2>&1 || {
    echo "Error: yq not found in PATH" >&2
    exit 1
}

case "$CMD" in
decrypt)
    decrypt
    ;;
encrypt)
    encrypt
    ;;
clean)
    clean
    ;;
*)
    usage
    ;;
esac
