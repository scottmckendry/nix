{ pkgs, config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  xdg.configFile."lazygit".source = mkOutOfStoreSymlink "${nixDir}/lazygit";
  home.packages = with pkgs; [
    lazygit
    delta
  ];
}
