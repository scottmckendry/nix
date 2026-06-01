#!/usr/bin/env bash
# Retrofit navigation links (← yesterday | tomorrow →) onto daily notes.
# Idempotent — skips notes that already have them.
# Requires $OBSIDIAN_PATH pointing at the vault root.

set -euo pipefail

if [ -z "${OBSIDIAN_PATH:-}" ]; then
    echo "Error: \$OBSIDIAN_PATH is not set" >&2
    exit 1
fi

VAULT_DIR="$OBSIDIAN_PATH"
DAILY_DIR="$VAULT_DIR/Daily"

if [ ! -d "$DAILY_DIR" ]; then
    echo "Error: Daily directory not found at '$DAILY_DIR'" >&2
    exit 1
fi

link_file() {
    local file="$1"
    local basename
    basename="$(basename "$file" .md)"
    local date_part="${basename:0:10}"

    # Validate date format YYYY-MM-DD
    if ! [[ "$date_part" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        return
    fi

    # Skip if nav line already present (check first 10 lines for speed)
    if head -10 "$file" | grep -q '^← \[\[.\+\]\] | \[\[.\+\]\] →'; then
        return
    fi

    local yesterday tomorrow nav_line insert_line
    yesterday="$(date -d "$date_part - 1 day" "+%Y-%m-%d-%A")"
    tomorrow="$(date -d "$date_part + 1 day" "+%Y-%m-%d-%A")"
    nav_line="← [[${yesterday}]] | [[${tomorrow}]] →"

    # Find line number of closing frontmatter delimiter (second ---)
    insert_line="$(awk '/^---$/{c++; if(c==2){print NR; exit}}' "$file")"

    if [ -n "$insert_line" ]; then
        # Insert blank line + nav line after closing ---
        sed -i "${insert_line}a\\\\n${nav_line}" "$file"
    else
        # No frontmatter: prepend blank line + nav line at top
        sed -i "1s/^/\\n${nav_line}\\n/" "$file"
    fi

    echo "  added: $(basename "$file") → $yesterday | $tomorrow"
}

echo "Scanning $DAILY_DIR ..."
while IFS= read -r -d '' file; do
    link_file "$file"
done < <(find "$DAILY_DIR" -maxdepth 1 -name '*.md' -print0 | sort -z)
echo "Done."
