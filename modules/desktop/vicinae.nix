{ utils, ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.vicinae ];
        systemd.user.services.vicinae = utils.mkWaylandService {
          description = "Vicinae Server";
          execStart = "${pkgs.vicinae}/bin/vicinae server";
        };
      };
  };
}
