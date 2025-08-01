{ pkgs, ... }:
let
  wpPath = "/home/scott/Pictures/Wallpapers/ship.jpg";
in
{
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wallpaper daemon for Wayland";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i ${wpPath}";
      Restart = "on-failure";
      RestartSec = 1;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
