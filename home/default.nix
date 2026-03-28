{ config, ... }:
{
  imports = [
    ./config.nix
    ./shared
    ./shell
  ];

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    OBSIDIAN_PATH = "${config.home.homeDirectory}/git/obsidian-vault";
  };

  home.stateVersion = "26.05";
  home.username = "scott";
  home.homeDirectory = "/home/scott";
}
