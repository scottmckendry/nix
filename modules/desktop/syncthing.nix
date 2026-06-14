{ ... }:
{
  den.aspects.niri-session = {
    nixos =
      {
        config,
        lib,
        ...
      }:
      lib.mkIf config.programs.niri.enable {
        services.syncthing = {
          enable = true;
          user = "scott";
          group = "users";
          dataDir = "/home/scott/Documents/syncthing";
        };
      };
  };
}
