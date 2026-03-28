{ ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.swayosd ];

        systemd.user.services.swayosd-server = {
          description = "SwayOSD server";
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session-pre.target" ];
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
            Restart = "on-failure";
            RestartSec = 1;
          };
        };
      };
  };
}
