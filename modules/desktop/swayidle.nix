{ ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      let
        timeouts = {
          lockScreen = 300; # 5 minutes
          turnOffMonitors = 600; # 10 minutes
          suspend = 1200; # 20 minutes
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
          description = "Idle/screen lock daemon for Wayland";
          partOf = [ "graphical-session.target" ];
          after = [ "graphical-session-pre.target" ];
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = swayidleCommand;
            Restart = "on-failure";
            RestartSec = 1;
          };
        };
      };
  };
}
