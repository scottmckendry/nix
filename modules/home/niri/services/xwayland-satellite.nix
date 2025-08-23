{ pkgs, ... }:
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
