{ ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.udiskie ];

        systemd.user.services.udiskie = {
          description = "udiskie - automounter for removable media";
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session-pre.target" ];
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.udiskie}/bin/udiskie";
            Restart = "on-failure";
            RestartSec = 1;
          };
        };
      };
  };
}
