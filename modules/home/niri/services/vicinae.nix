{ pkgs, ... }:
{
  programs.vicinae = {
    enable = true;
    settings = {
      font.size = 10;
      font.normal = "JetBrainsMono Nerd Font";
      window.opacity = 1;
    };
  };
  systemd.user.services.vicinae = {
    Unit = {
      Description = "Vicinae Server";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.vicinae}/bin/vicinae server";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
