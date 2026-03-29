{ utils, ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.waybar ];

        systemd.user.services.waybar = utils.mkWaylandService {
          description = "Waybar status bar for Wayland";
          execStart = "${pkgs.waybar}/bin/waybar";
          extraServiceConfig = {
            ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
          };
        };
      };
  };
}
