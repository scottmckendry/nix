{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

let
  timeout = 300;
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
          inherit timeout;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = timeout + 30;
          on-timeout = hyprlockExe;
        }
        {
          timeout = timeout + 60;
          on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
