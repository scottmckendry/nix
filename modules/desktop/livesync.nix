{ ... }:
{
  den.aspects.niri-session = {
    nixos = { pkgs, config, lib, ... }: lib.mkIf config.programs.niri.enable {
      systemd.user.services.livesync = {
        description = "Obsidian LiveSync CLI - headless vault sync daemon";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.obsidian-livesync-cli}/bin/livesync-cli %h/git/obsidian";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
  };
}
