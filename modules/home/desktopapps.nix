{ pkgs, ... }:

{
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
