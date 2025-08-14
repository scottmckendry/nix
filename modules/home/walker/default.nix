{
  pkgs,
  inputs,
  config,
  ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      search.placeholder = "Search...";
      ui.fullscreen = true;
      websearch.prefix = "?";
      switcher.prefix = "/";
      theme = "cyberdream";
      terminal = "kitty";
    };
  };

  home.packages = with pkgs; [
    libqalculate
    lua
  ];

  xdg.configFile."walker/themes".source = mkOutOfStoreSymlink "${nixDir}/modules/home/walker/themes";
}
