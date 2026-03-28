{ pkgs, config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  imports = [
    ./hyprlock.nix
    ./mako.nix
    ./termfilechooser.nix
    ./vicinae.nix
  ];

  home.packages = with pkgs; [
    blueman
    brightnessctl
    cliphist
    grim
    inotify-tools
    nmgui
    playerctl
    slurp
    tesseract
    wl-clipboard
  ];

  xdg.configFile."niri".source = mkOutOfStoreSymlink "${nixDir}/home/desktop/niri/config";
  xdg.configFile."waybar".source = mkOutOfStoreSymlink "${nixDir}/home/desktop/waybar";
}
