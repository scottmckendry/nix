{ pkgs, ... }:

{
  stylix.targets.gtk.enable = false;
  home.packages = with pkgs; [
    brave
    firefox
    nautilus
    spotify
    vesktop
  ];
}
