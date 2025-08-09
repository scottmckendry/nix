{ pkgs, config, ... }:
let
  # Home directory for the user
  homeDir = config.home.homeDirectory;
  scriptPath = "${homeDir}/scripts/battery-monitor.sh";
in
{
  systemd.user.services."battery-monitor" = {
    Unit = {
      Description = "Battery monitor notification script";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${scriptPath}";
    };
    Install = {
      WantedBy = [ "battery-monitor.timer" ];
    };
  };

  systemd.user.timers."battery-monitor" = {
    Unit = {
      Description = "Run battery-monitor.sh every 30 seconds";
    };
    Timer = {
      OnBootSec = "30";
      OnUnitActiveSec = "30";
      Unit = "battery-monitor.service";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
