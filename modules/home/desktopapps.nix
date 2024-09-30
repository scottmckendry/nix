{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    firefox
    nautilus
    spotify
    vesktop
  ];
}
