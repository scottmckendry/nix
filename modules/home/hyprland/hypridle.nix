{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

let
  timeout = 600;
  hyprlockExe = "pidof hyprlock || ${lib.getExe config.programs.hyprlock.package}";

in
{
  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages.${pkgs.system}.hypridle;

    settings = {
      general = rec {
        lock_cmd = hyprlockExe;
        before_slep_cmd = lock_cmd;
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          inherit timeout; # turn off screen/s after 10 minutes
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = timeout + 300; # lock after 15 minutes
          on-timeout = hyprlockExe;
        }
        {
          # hibernate after 2 hours
          timeout = timeout * 12;
          on-timeout = "${pkgs.systemd}/bin/systemctl hibernate";
        }
      ];
    };
  };
}
