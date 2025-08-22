{ pkgs, config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  services.walker = {
    enable = true;
    settings = {
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
  ];

  xdg.configFile."walker/themes".source = mkOutOfStoreSymlink "${nixDir}/modules/home/walker/themes";
}
