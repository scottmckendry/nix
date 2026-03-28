{ ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      let
        scriptPath = "/home/scott/scripts/battery-monitor.sh";
      in
      {
        systemd.user.services."battery-monitor" = {
          description = "Battery monitor notification script";
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session-pre.target" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.bash}/bin/bash ${scriptPath}";
          };
        };

        systemd.user.timers."battery-monitor" = {
          description = "Run battery-monitor.sh every 30 seconds";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "30";
            OnUnitActiveSec = "30";
            Unit = "battery-monitor.service";
          };
        };
      };
  };
}
