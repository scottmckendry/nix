{ config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  xdg.configFile."nvim".source = mkOutOfStoreSymlink "${nixDir}/nvim";
  home.file."scripts".source = mkOutOfStoreSymlink "${nixDir}/scripts";
}
