{
  pkgs,
  config,
  inputs,
  desktop,
  ...
}:

{
  imports = [
    ./dev
    ./desktop
    ./packages
    ./shared
    ./shell
  ];

  programs.fastfetch.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    OBSIDIAN_PATH = "${config.home.homeDirectory}/git/obsidian-vault";
  };

  home.stateVersion = "24.05";
}
