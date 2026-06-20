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
        environment.systemPackages = [ pkgs.quickshell ];

        systemd.user.services.quickshell = utils.mkWaylandService {
          description = "Quickshell desktop shell";
          execStart = "${pkgs.quickshell}/bin/quickshell";
        };
      };
  };
}
