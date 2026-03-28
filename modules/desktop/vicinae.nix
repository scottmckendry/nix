{ ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.vicinae ];

        systemd.user.services.vicinae = {
          description = "Vicinae Server";
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session-pre.target" ];
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.vicinae}/bin/vicinae server";
            Restart = "on-failure";
            RestartSec = 1;
            Environment = "PATH=/run/current-system/sw/bin:%h/.nix-profile/bin:${pkgs.vicinae}/bin";
          };
        };
      };
  };
}
