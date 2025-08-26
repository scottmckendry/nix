{ hostname, ... }:

let
  output = if hostname == "atlas" then "DP-1" else "eDP-1";
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = {
        path = "/tmp/current_wallpaper";
        blur_passes = 2;
        blur_size = 4;
      };

      input-field = {
        monitor = output;
        size = "250, 60";
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.2)";
        font_color = "rgba(200, 200, 200, 1)";
      };

      # clock
      label = {
        monitor = output;
        text = "cmd[update:1000] echo -n $(date +'%-I:%M %p')";
        size = "250, 60";
        color = "rgba(200, 200, 200, 1)";
        font_size = 45;
        font_family = "Inter";
        position = "0, 100";
        halign = "center";
        valign = "center";
      };
    };
  };
}
