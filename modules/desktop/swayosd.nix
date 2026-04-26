{ utils, ... }:
{
  den.aspects.niri-session = {
    nixos =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      lib.mkIf config.programs.niri.enable {
        environment.systemPackages = [ pkgs.swayosd ];

        systemd.user.services.swayosd-server = utils.mkWaylandService {
          description = "SwayOSD server";
          execStart = "${pkgs.swayosd}/bin/swayosd-server";
        };
      };
  };
}
