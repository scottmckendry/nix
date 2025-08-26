{ ... }:

{
  programs.niri.settings = {
    window-rules = [
      # Rounded corners for all windows
      {
        geometry-corner-radius = {
          top-left = 15.0;
          top-right = 15.0;
          bottom-left = 15.0;
          bottom-right = 15.0;
        };
        clip-to-geometry = true;
      }

      # Zen PiP: always floating
      {
        matches = [
          {
            app-id = ''(?i)^zen$'';
            title = ''^Picture-in-Picture$'';
          }
        ];
        open-floating = true;
      }

      # Floating windows: always floating
      {
        matches = [ { app-id = ''(?i)(nautilus|blueberry|pavucontrol|keepass|nm-connection-editor)''; } ];
        open-floating = true;
      }

      # Secondary monitor apps: maximized by default
      {
        matches = [ { app-id = ''(?i)^(spotify|teams-for-linux|discord|vesktop)$''; } ];
        open-on-output = "HDMI-A-1";
        open-maximized = true;
      }
    ];

    layer-rules = [
      # Wallpaper stays in place when switching workspaces
      {
        matches = [ { namespace = ''(?i)^swww-daemon$''; } ];
        place-within-backdrop = true;
      }
    ];
  };
}
