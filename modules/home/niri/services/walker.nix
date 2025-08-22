{ pkgs, ... }:

{
  systemd.user.services.walker = {
    Unit = {
      Description = "Walker Application Launcher";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };

    Service = {
      Type = "simple";
      Environment = "DISPLAY=:0"; # for xwayland apps
      ExecStart = "${pkgs.walker}/bin/walker --gapplication-service";
      Restart = "on-failure";
      RestartSec = 1;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
