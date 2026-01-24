{
  config,
  desktop ? false,
  ...
}:

{
  imports = [
    ./dev
    ./shared
    ./shell
    ./packages
  ]
  ++ (
    if desktop then
      [
        ./desktop
      ]
    else
      [ ]
  );

  programs.fastfetch.enable = true;
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    OBSIDIAN_PATH = "${config.home.homeDirectory}/git/obsidian-vault";
  };

  home.stateVersion = "24.05";
  home.username = "scott";
  home.homeDirectory = "/home/scott";
}
