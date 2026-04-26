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
        environment.systemPackages = [ pkgs.awww ];
        systemd.user.services.awww = utils.mkWaylandService {
          description = "awww wallpaper daemon";
          execStart = "${pkgs.awww}/bin/awww-daemon";
          wantedBy = true;
        };
      };
  };
}
