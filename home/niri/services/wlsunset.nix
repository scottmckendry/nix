{ pkgs, ... }:
{
  systemd.user.services.wlsunset = {
    Unit = {
      Description = "wlsunset - day/night gamma adjustments for wayland";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.wlsunset}/bin/wlsunset";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };
}
