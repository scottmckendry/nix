{ ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.wlsunset ];

        systemd.user.services.wlsunset = {
          description = "wlsunset - day/night gamma adjustments for wayland";
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session-pre.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.wlsunset}/bin/wlsunset";
            Restart = "on-failure";
            RestartSec = 1;
          };
        };
      };
  };
}
