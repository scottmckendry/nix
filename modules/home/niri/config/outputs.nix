{ hostname, ... }:

{
  # Choose different Niri output layouts per host
  programs.niri.settings.outputs =
    if hostname == "atlas" then {
      "DP-1" = {
        name = "DP-1";
        mode = {
          width = 3440;
          height = 1440;
          refresh = 144.00;
        };
        scale = 1;
        position = {
          x = 0;
          y = 0;
        };
      };
      "HDMI-A-1" = {
        name = "HDMI-A-1";
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.00;
        };
        transform.rotation = 270;
        position = {
          x = -1080;
          y = -400;
        };
      };
    }
      else if hostname == "eris" then {
      "eDP-1" = {
        name = "eDP-1";
        mode = {
          width = 2400;
          height = 1600;
          refresh = 120.00;
        };
        scale = 1.2;
        variable-refresh-rate = true;
        position = {
          x = 864;
          y = 1080;
        };
      };
      "DP-1" = {
        name = "DP-1";
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.00;
        };
        position = {
          x = 0;
          y = 0;
        };
      };
      "DP-6" = {
        name = "DP-6";
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.00;
        };
        position = {
          x = 1920;
          y = 0;
        };
      };
    }
    else {};
}
