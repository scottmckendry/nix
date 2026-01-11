{ pkgs, ... }:
{
  systemd.user.services.udiskie = {
    Unit = {
      Description = "udiskie - automounter for removable media";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.udiskie}/bin/udiskie";
      Restart = "on-failure";
      RestartSec = 1;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  home.packages = [ pkgs.udiskie ];
}
