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
        environment.systemPackages = [
          pkgs.vicinae
          pkgs.uwsm
        ];
        systemd.user.services.vicinae = utils.mkWaylandService {
          description = "Vicinae Server";
          execStart = "${pkgs.vicinae}/bin/vicinae server";
        };
      };
  };
}
