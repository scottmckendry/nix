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
  home.packages = with pkgs; [
    blueberry
    inotify-tools
    swaybg
    waybar
  ];

  xdg.configFile."niri".source = mkOutOfStoreSymlink "${nixDir}/niri";
  xdg.configFile."quickshell".source = mkOutOfStoreSymlink "${nixDir}/quickshell";
  services.dunst.enable = true; # TODO: experiment with mako
}
