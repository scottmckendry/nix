{ inputs, lib, ... }:
{
  den.aspects.scott = {
    hjem =
      { pkgs, ... }:
      let
        system = pkgs.stdenv.hostPlatform.system;
        vicinaeExts = inputs.vicinae-extensions.packages.${system};
        extNames = [
          "awww-switcher"
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
