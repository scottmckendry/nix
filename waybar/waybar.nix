{ config, pkgs, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix/";
in
{
  # Create symlinks to the config files - this enables hot reloading
  xdg.configFile."waybar/style.css".source = mkOutOfStoreSymlink "${nixDir}/waybar/style.css";
  xdg.configFile."waybar/waybar-hot-reload.sh".source = mkOutOfStoreSymlink "${nixDir}/waybar/waybar-hot-reload.sh";
  xdg.configFile."waybar/config.jsonc".source = mkOutOfStoreSymlink "${nixDir}/waybar/config.jsonc";

  # add packages
  home.packages = with pkgs; [ waybar ];
}
