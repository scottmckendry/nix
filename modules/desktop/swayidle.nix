{ utils, ... }:
{
  den.aspects.niri-session = {
    nixos =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      let
        timeouts = {
          lockScreen = 300; # 5 minutes
          turnOffMonitors = 600; # 10 minutes
          suspend = 1200; # 20 minutes
        };

        commands = {
          lock = "pgrep -x hyprlock > /dev/null || hyprlock --grace 5 &";
          lockImmediate = "pgrep -x hyprlock > /dev/null || hyprlock &";
          screenOff = "niri msg action power-off-monitors";
          suspend = "systemctl suspend";
        };

        swayidleCommand =
          "${pkgs.swayidle}/bin/swayidle -w"
          + " timeout ${toString timeouts.lockScreen} '${commands.lock}'"
          + " timeout ${toString timeouts.turnOffMonitors} '${commands.screenOff}'"
          + " timeout ${toString timeouts.suspend} '${commands.suspend}'"
          + " before-sleep '${commands.lockImmediate}'"
          + " lock '${commands.lockImmediate}'";
      in
      lib.mkIf config.programs.niri.enable {
        systemd.user.services.swayidle = utils.mkWaylandService {
          description = "Idle/screen lock daemon for Wayland";
          execStart = swayidleCommand;
        };
      };
  };
}
