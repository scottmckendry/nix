{ utils, ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.wlsunset ];

        systemd.user.services.wlsunset = utils.mkWaylandService {
          description = "wlsunset - day/night gamma adjustments for wayland";
          execStart = "${pkgs.wlsunset}/bin/wlsunset";
          wantedBy = false;
        };
      };
  };
}
