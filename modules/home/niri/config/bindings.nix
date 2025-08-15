{ config, ... }:

{
  programs.niri.settings = with config.lib.niri.actions; {
    binds = {
      # Applications / Utility
      "Mod+RETURN".action = spawn "kitty";
      "Mod+Shift+B".action = spawn "zen";
      "Mod+R".action = spawn "walker";
      "Mod+Alt+L".action = spawn "hyprlock";
      "Mod+E".action = spawn "nautilus";
      "Mod+V".action = spawn "walker" "-m" "clipboard";
      "Mod+Shift+Period".action = spawn "walker" "-m" "emojis";
      "Mod+Shift+W".action = spawn "~/scripts/window-switcher.sh";
      "Mod+Shift+S".action = screenshot;

      # Media Keys
      "XF86AudioMicMute" = { allow-when-locked = true; action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; };
      "XF86AudioPlay" = { allow-when-locked = true; action = spawn "playerctl" "play-pause"; };
      "XF86AudioNext" = { allow-when-locked = true; action = spawn "playerctl" "next"; };
      "XF86AudioPrev" = { allow-when-locked = true; action = spawn "playerctl" "previous"; };
      "XF86AudioMute" = { allow-when-locked = true; action = spawn "~/scripts/volume-osd.sh" "--mute"; };
      "XF86AudioRaiseVolume" = { allow-when-locked = true; action = spawn "~/scripts/volume-osd.sh" "--inc"; };
      "XF86AudioLowerVolume" = { allow-when-locked = true; action = spawn "~/scripts/volume-osd.sh" "--dec"; };
      "XF86MonBrightnessUp" = { allow-when-locked = true; action = spawn "~/scripts/brightness-osd.sh" "--inc"; };
      "XF86MonBrightnessDown" = { allow-when-locked = true; action = spawn "~/scripts/brightness-osd.sh" "--dec"; };

      # Window/Workspace/Layout
      "Mod+O" = { repeat = false; action = toggle-overview; };
      "Mod+Q".action = close-window;
      "Mod+H".action = focus-column-left;
      "Mod+J".action = focus-window-down;
      "Mod+K".action = focus-window-up;
      "Mod+L".action = focus-column-right;
      "Mod+Ctrl+H".action = move-column-left;
      "Mod+Ctrl+J".action = move-window-down;
      "Mod+Ctrl+K".action = move-window-up;
      "Mod+Ctrl+L".action = move-column-right;
      "Mod+Shift+H".action = focus-monitor-left;
      "Mod+Shift+J".action = focus-monitor-down;
      "Mod+Shift+K".action = focus-monitor-up;
      "Mod+Shift+L".action = focus-monitor-right;
      "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
      "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
      "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
      "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;
      "Mod+Alt+J".action = move-column-to-workspace-down;
      "Mod+Alt+K".action = move-column-to-workspace-up;
      "Mod+W".action = toggle-column-tabbed-display;
      "Mod+Comma".action = consume-or-expel-window-left;
      "Mod+Period".action = consume-or-expel-window-left;
      "Mod+Shift+R".action = switch-preset-column-width;
      "Mod+Ctrl+R".action = reset-window-height;
      "Mod+F".action = maximize-column;
      "Mod+Shift+F".action = fullscreen-window;
      "Mod+Ctrl+F".action = expand-column-to-available-width;
      "Mod+Shift+V".action = toggle-window-floating;
      "Mod+C".action = center-column;
      "Mod+Ctrl+C".action = center-visible-columns;
      "Mod+Minus".action = set-column-width "-10%";
      "Mod+Equal".action = set-column-width "+10%";
      "Mod+Shift+Minus".action = set-window-height "-10%";
      "Mod+Shift+Equal".action = set-window-height "+10%";
      "Mod+WheelScrollDown" = { cooldown-ms = 150; action = focus-workspace-down; };
      "Mod+WheelScrollUp" = { cooldown-ms = 150; action = focus-workspace-up; };
      "Mod+Ctrl+WheelScrollDown" = { cooldown-ms = 150; action = move-column-to-workspace-down; };
      "Mod+Ctrl+WheelScrollUp" = { cooldown-ms = 150; action = move-column-to-workspace-up; };

      # System Actions
      "Mod+Shift+P".action = power-off-monitors;
      "Mod+Shift+Q".action = quit;
    };
  };
}
