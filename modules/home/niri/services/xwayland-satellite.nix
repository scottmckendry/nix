{ pkgs, ... }:

# TODO: once xwayland-satellite is v0.7.0 or later, remove this service
# use use the built-in niri integration instead, supported since v25.08
{
  home.sessionVariables = {
    DISPLAY = ":0";
    NIXOS_OZONE_WL = "1";
  };

  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "XWayland Satellite Service";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      Restart = "on-failure";
      RestartSec = 1;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
