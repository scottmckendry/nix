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
      lib.mkIf config.programs.niri.enable {
        # see https://github.com/vrtmrz/obsidian-livesync/tree/main/src/apps/cli
        systemd.user.services.obsidian-livesync = utils.mkWaylandService {
          description = "Obsidian LiveSync CLI - headless vault sync daemon";
          # TODO: only --verbose and --debug args for log levels are supported. But info is really what I want.
          # consider submitting patch upstream to add --log-level arg or similar for more control over log verbosity.
          execStart = "${pkgs.obsidian-livesync-cli}/bin/livesync-cli %h/Documents/obsidian --verbose";
          extraServiceConfig = {
            RestartSec = 5;
          };
        };
      };
  };
}
