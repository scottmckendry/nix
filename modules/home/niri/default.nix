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
    swayosd
    waybar
  ];

  xdg.configFile."niri".source = mkOutOfStoreSymlink "${nixDir}/modules/home/niri/config";
}
