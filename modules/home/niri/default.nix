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
  ];

  home.packages = with pkgs; [
    blueberry
    inotify-tools
    swaybg
    waybar
  ];

  xdg.configFile."niri/config.kdl".source =
    mkOutOfStoreSymlink "${nixDir}/modules/home/niri/config.kdl";
  services.dunst.enable = true; # TODO: experiment with mako
}
