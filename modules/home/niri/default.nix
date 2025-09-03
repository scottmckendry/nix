{ pkgs, config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  imports = [
    ./hyprlock.nix
    ./mako.nix
    ./services
  ];

  home.packages = with pkgs; [
    blueberry
    brightnessctl
    cliphist
    inotify-tools
    nmgui
    playerctl
    waybar
  ];

  xdg.configFile."niri/config.kdl".source =
    mkOutOfStoreSymlink "${nixDir}/modules/home/niri/config.kdl";
}
