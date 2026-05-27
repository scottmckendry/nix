{ utils, ... }:
{
  den.aspects.niri-session = {
    nixos = { pkgs, config, lib, ... }: lib.mkIf config.programs.niri.enable {
      systemd.user.services.livesync = utils.mkWaylandService {
        description = "Obsidian LiveSync CLI - headless vault sync daemon";
        execStart = "${pkgs.obsidian-livesync-cli}/bin/livesync-cli %h/Documents/obsidian";
        extraServiceConfig = {
          RestartSec = 5;
        };
      };
    };
  };
}
