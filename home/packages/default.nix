{ pkgs, ... }:
{
  imports = [
    ./dev.nix
    ./devops.nix
    ./tools.nix
  ];
}
