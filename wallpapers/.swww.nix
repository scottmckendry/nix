{ config, pkgs, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix/";
in
{
  home.packages = with pkgs; [
    swww
  ];

  xdg.configFile."wallpapers".source = mkOutOfStoreSymlink "${nixDir}/wallpapers";
}
