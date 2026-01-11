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
    ./termfilechooser.nix
  ];

  home.packages = with pkgs; [
    blueberry
    brightnessctl
    cliphist
    grim
    inotify-tools
    nmgui
    playerctl
    slurp
    swayosd
    tesseract
    waybar
    wl-clipboard
  ];

  xdg.configFile."niri".source = mkOutOfStoreSymlink "${nixDir}/home/niri/config";
}
