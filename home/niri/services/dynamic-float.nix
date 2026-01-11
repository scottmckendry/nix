{ pkgs, config, ... }:
let
  homeDir = config.home.homeDirectory;
  scriptPath = "${homeDir}/scripts/dynamic-float.py";
in
{
  systemd.user.services."dynamic-float" = {
    Unit = {
      Description = "Niri dynamic floating window script";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.python3}/bin/python ${scriptPath}";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
