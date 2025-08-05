{ ... }:
{
  home.file."scripts/hyprlock.sh" = {
    source = ./hyprlock.sh;
    executable = true;
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      animations = {
        animation = [
          "fadeIn, 0, 0, linear"
          "fadeOut, 0, 0, linear"
        ];
      };

      background = {
        monitor = "";
        path = "/tmp/current_wallpaper";
        blur_passes = 2;
        blur_size = 4;
      };

      input-field = {
        monitor = "DP-1";
        size = "250, 60";
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.2)";
        font_color = "rgba(200, 200, 200, 1)";
      };

      # clock
      label = {
        monitor = "DP-1";
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
