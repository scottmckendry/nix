-- Walker Plugin: Wallpaper Switcher (Lua)
-- Lists wallpapers and sets the selected one as the current wallpaper for swaybg & swaylock.
-- For debugging, test with: `lua modules/home/walker/plugins/wallpaper.lua entries`
--- @diagnostic disable: lowercase-global

local WALLPAPER_DIR = os.getenv("HOME") .. "/Pictures/Wallpapers"
local CACHE_FILE = "/tmp/current_wallpaper"

function info()
    print('placeholder = "Select a wallpaper"')
    print('name = "wallpaper"')
    print("switcher_only = true")
    print('parser = "kv"')
end

function entries()
    local find_cmd = string.format(
        "find -L '%s' -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.webp' \\)",
        WALLPAPER_DIR
    )
    local handle = io.popen(find_cmd)
    if not handle then
        error("Failed to list wallpapers")
    end
    for path in handle:lines() do
        local label = path:match("([^/]+)$") or path
        local exec = string.format(
            "ln -sf '%s' '%s' && niri msg action do-screen-transition --delay-ms 400 && systemctl --user restart swaybg.service",
            path,
            CACHE_FILE
        )
        print(string.format("label=%s;exec=%s;image=%s;recalculate_score=true;value=%s", label, exec, path, path))
    end
    handle:close()
end

local arg = arg or { ... }
if arg[1] == "info" then
    info()
elseif arg[1] == "entries" then
    entries()
else
    error(string.format("Usage: %s {info|entries}", arg[0] or "plugin"))
end
