{ utils, ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.udiskie ];

        systemd.user.services.udiskie = utils.mkWaylandService {
          description = "udiskie - automounter for removable media";
          execStart = "${pkgs.udiskie}/bin/udiskie";
        };
      };
  };
}
