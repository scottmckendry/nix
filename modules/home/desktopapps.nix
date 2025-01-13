{ pkgs, ... }:

{
  stylix.targets.gtk.enable = false;
  home.packages = with pkgs; [
    brave
    dolphin
    firefox
    gimp
    spotify
    vesktop
    wl-clipboard
  ];
}
