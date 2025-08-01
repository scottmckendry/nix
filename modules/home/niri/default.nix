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
    ./swaylock.nix
  ];

  home.packages = with pkgs; [
    blueberry
    cliphist
    inotify-tools
    playerctl
    waybar
  ];

  xdg.configFile."niri/config.kdl".source =
    mkOutOfStoreSymlink "${nixDir}/modules/home/niri/config.kdl";
  xdg.configFile."waybar".source = mkOutOfStoreSymlink "${nixDir}/waybar";
  services.dunst.enable = true; # TODO: experiment with mako
}
