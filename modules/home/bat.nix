{ pkgs, config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  home.packages = with pkgs; [ bat ];
  xdg.configFile."bat".source = mkOutOfStoreSymlink "${nixDir}/bat";

  home.activation.batSetup = config.lib.dag.entryBefore [ "writeBoundary" ] ''
    ${pkgs.bat}/bin/bat cache --clear
    ${pkgs.bat}/bin/bat cache --build
  '';
}
