{ config, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      hide_cursor = true;
      grace = 0;
      background = {
        monitor = "";
        path = "${config.stylix.image}";
        blur_passes = 2;
      };
      input-field = {
        monitor = "DP-2";
        size = "250, 60";
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.2)";
        font_color = "rgba(200, 200, 200, 1)";
      };
      # clock
      label = {
        monitor = "DP-2";
        text = "cmd[update:1000] echo -n $(date +'%-I:%M %p')";
        size = "250, 60";
        color = "rgba(200, 200, 200, 1)";
        font_size = 45;
        font_family = "JetBrains Mono";
        position = "0, 100";
        halign = "center";
        valign = "center";
      };
    };
  };
}
