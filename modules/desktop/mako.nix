{ utils, ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.mako ];

        systemd.user.services.mako = utils.mkWaylandService {
          description = "Lightweight Wayland notification daemon";
          execStart = "${pkgs.mako}/bin/mako";
          type = "dbus";
          extraServiceConfig = {
            BusName = "org.freedesktop.Notifications";
            ExecCondition = "${pkgs.bash}/bin/sh -c '[ -n \"$WAYLAND_DISPLAY\" ]'";
            ExecReload = "${pkgs.mako}/bin/makoctl reload";
          };
        };
      };
  };
}
