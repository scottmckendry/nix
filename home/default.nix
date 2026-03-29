{ ... }:
{
  imports = [
    ./config.nix
  ];

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "26.05";
  home.username = "scott";
  home.homeDirectory = "/home/scott";
}
