#!/usr/bin/env bash

# Walker Window Switcher for Niri
# Shows a dmenu-style window switcher using walker and niri

# Format application ID by removing common prefixes and capitalizing first letter
clean_app_id() {
    local app="$1"
    # Remove common application prefixes
    app=$(echo "$app" | sed -E 's/^(org\.gnome\.|org\.|com\.|net\.)//')
    # Capitalize first letter
    app=$(echo "$app" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
    echo "$app"
}

clean_title() {
    local title="$1"
    # Remove common separators and trailing content
    title=$(echo "$title" | sed -E 's/ · .*//; s/ — .*//')
    # Remove leading/trailing whitespace
    title=$(echo "$title" | sed -E 's/^ +| +$//g')

    # Truncate long titles
    local max_length=48
    if [ "${#title}" -gt "$max_length" ]; then
        title="${title:0:$(($max_length - 3))}…"
    fi
    echo "$title"
}

local windows_json
windows_json=$(niri msg --json windows)

# Initialize arrays for window information
local -a display_arr=()
local -a id_arr=()

# Process each window and build the display list
while IFS=$'\t' read -r title app_id id; do
    local cleaned_title
    cleaned_title=$(clean_title "$title")
    local cleaned_app
    cleaned_app=$(clean_app_id "$app_id")

    # Use app name as title if title is empty
    [ -z "$cleaned_title" ] && cleaned_title="$cleaned_app"

    display_arr+=("${cleaned_title} - ${cleaned_app}")
    id_arr+=("$id")
done < <(echo "$windows_json" | jq -r '.[] | [.title, .app_id, .id] | @tsv')

# Show window selector using walker
local selected
selected=$(printf "%s\n" "${display_arr[@]}" | walker --dmenu -p "Select a window to jump to...")

# Find selected window ID and focus it
local win_id=""
for i in "${!display_arr[@]}"; do
    [[ "${display_arr[$i]}" == "$selected" ]] && {
        win_id="${id_arr[$i]}"
        break
    }
done

# Focus the selected window if one was chosen
[[ -n "$win_id" ]] && niri msg action focus-window --id "$win_id"
