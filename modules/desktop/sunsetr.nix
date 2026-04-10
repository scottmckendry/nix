{ utils, ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.sunsetr ];

        systemd.user.services.sunsetr = utils.mkWaylandService {
          description = "sunsetr - day/night gamma adjustments for wayland";
          execStart = "${pkgs.sunsetr}/bin/sunsetr";
          wantedBy = true;
        };
      };
  };
}
