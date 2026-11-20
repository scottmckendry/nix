{ inputs, ... }:
{
  den.aspects.nix-settings = {
    nixos =
      { host, pkgs, ... }:
      {
        nix.settings = {
          warn-dirty = false;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          substituters = [
            "https://cache.nixos.org"
            "https://scottmckendry.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "scottmckendry.cachix.org-1:jB2i6xNpH0TiZfTe2p3VfIejB3nUT8bf7PYsn9uOV3I="
          ];
        };

        programs.nix-ld.enable = true;
        programs.nh = {
          enable = true;
          flake = host.settings.fleet.repoRoot;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 3";
        };

        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = import ../../overlays { inherit inputs; };
        boot.kernelPackages = pkgs.linuxPackages_latest;
        system.stateVersion = "26.05";
      };
  };
}
