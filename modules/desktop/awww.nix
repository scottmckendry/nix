{ utils, ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.awww ];
        systemd.user.services.awww = utils.mkWaylandService {
          description = "awww wallpaper daemon";
          execStart = "${pkgs.awww}/bin/awww-daemon";
          wantedBy = true;
        };
      };
  };
}
