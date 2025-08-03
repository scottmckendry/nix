-- Walker Plugin: Niri Window Switcher
-- This plugin retrieves window information from the Niri messaging system and formats it for use in Walker.
-- For debugging, test with: `lua modules/home/walker/plugins/window.lua entries`
--- @diagnostic disable: lowercase-global

function info()
    print('placeholder = "Pick a window to jump to..."')
    print('name = "window"')
    print("switcher_only = true")
    print('parser = "kv"')
end

function entries()
    local handle = io.popen("niri msg windows")
    if not handle then
        error("Failed to execute 'niri msg windows'")
    end

    local output = handle:read("*a")
    local success, close_err = handle:close()
    if not success then
        error("Failed to close handle: " .. (close_err or "unknown error"))
    end

    -- Split output into window blocks
    local windows = {}
    for block in output:gmatch("Window ID%s+%d+:.-\n\n") do
        table.insert(windows, block)
    end

    for _, window in ipairs(windows) do
        local id = window:match("Window ID%s+(%d+):")
        local title = window:match('Title:%s+"([^"]+)"')
        local app = window:match('App ID:%s+"([^"]+)"')

        if id and title and app then
            app = app:gsub("^org%.", ""):gsub("^com%.", ""):gsub("%.", " "):gsub("^%l", string.upper)
            local label = string.format("%s [%s]", title, app)
            local exec = string.format("niri msg action focus-window --id %s", id)
            print(string.format("label=%s;exec=%s;value=%s", label, exec, id))
        end
    end
end

local arg = arg or { ... }
if arg[1] == "info" then
    info()
elseif arg[1] == "entries" then
    entries()
else
    error(string.format("Usage: %s {info|entries}", arg[0] or "plugin"))
end
