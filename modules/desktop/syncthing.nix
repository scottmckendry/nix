{ ... }:
{
  den.aspects.niri-session = {
    nixos =
      { config, lib, ... }:
      lib.mkIf config.programs.niri.enable {
        services.syncthing = {
          enable = true;
          user = "scott";
          group = "users";
          dataDir = "${config.users.users.scott.home}/Documents/syncthing";
        };
      };
  };
}
