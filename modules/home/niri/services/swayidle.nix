{ pkgs, ... }:

let
  timeouts = {
    lockScreen = 300; # 5 minutes
    turnOffMonitors = 600; # 10 minutes
    suspend = 7200; # 2 hours
  };

  commands = {
    lock = "pgrep -x hyprlock > /dev/null || hyprlock --grace 5 &";
    screenOff = "niri msg action power-off-monitors";
    suspend = "systemctl suspend";
  };

  swayidleCommand =
    "${pkgs.swayidle}/bin/swayidle -w"
    + " timeout ${toString timeouts.lockScreen} '${commands.lock}'"
    + " timeout ${toString timeouts.turnOffMonitors} '${commands.screenOff}'"
    + " timeout ${toString timeouts.suspend} '${commands.suspend}'"
    + " before-sleep '${commands.lock}'";
in

{
  systemd.user.services.swayidle = {
    Unit = {
      Description = "Idle/screen lock daemon for Wayland";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = swayidleCommand;
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
