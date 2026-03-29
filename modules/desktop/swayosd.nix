{ utils, ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.swayosd ];

        systemd.user.services.swayosd-server = utils.mkWaylandService {
          description = "SwayOSD server";
          execStart = "${pkgs.swayosd}/bin/swayosd-server";
        };
      };
  };
}
