{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-desktop
    brave
    discord
    firefox
    gimp
    nautilus
    spotify
    wl-clipboard
  ];
}
