{ ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.mako ];

        systemd.user.services.mako = {
          description = "Lightweight Wayland notification daemon";
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "dbus";
            BusName = "org.freedesktop.Notifications";
            ExecCondition = "/bin/sh -c '[ -n \"$WAYLAND_DISPLAY\" ]'";
            ExecStart = "${pkgs.mako}/bin/mako";
            ExecReload = "${pkgs.mako}/bin/makoctl reload";
          };
        };
      };
  };
}
