{ ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.waybar ];

        systemd.user.services.waybar = {
          description = "Waybar status bar for Wayland";
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session-pre.target" ];
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.waybar}/bin/waybar";
            Restart = "on-failure";
            RestartSec = 1;
            ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
          };
        };
      };
  };
}
