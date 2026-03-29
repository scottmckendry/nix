{
  inputs,
  lib,
  utils,
  ...
}:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.vicinae ];
        systemd.user.services.vicinae = utils.mkWaylandService {
          description = "Vicinae Server";
          execStart = "${pkgs.vicinae}/bin/vicinae server";
        };
      };

    hjem =
      { pkgs, ... }:
      let
        system = pkgs.stdenv.hostPlatform.system;
        vicinaeExts = inputs.vicinae-extensions.packages.${system};
        extNames = [
          "html-symbol-finder"
          "nix"
          "spongebob-text-transformer"
        ];
      in
      {
        files = lib.listToAttrs (
          map (
            name: lib.nameValuePair ".local/share/vicinae/extensions/${name}" { source = vicinaeExts.${name}; }
          ) extNames
        );
      };
  };
}
