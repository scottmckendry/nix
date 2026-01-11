{ pkgs, config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  xdg.configFile."waybar".source = mkOutOfStoreSymlink "${nixDir}/home/waybar";

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar status bar for Wayland";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash ${config.xdg.configHome}/waybar/waybar-hot-reload.sh";
      Restart = "on-failure";
      RestartSec = 1;
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
