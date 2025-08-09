{
  pkgs,
  config,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  imports = [
    ./services
    ./hyprlock.nix
    ./mako.nix
  ];

  home.packages = with pkgs; [
    blueberry
    brightnessctl
    cliphist
    inotify-tools
    networkmanagerapplet
    playerctl
    waybar
  ];

  xdg.configFile."niri/config.kdl".source =
    mkOutOfStoreSymlink "${nixDir}/modules/home/niri/config.kdl";

  # Mask nm-applet autostart to prevent tray icon
  xdg.configFile."autostart/nm-applet.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
}
