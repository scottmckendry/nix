{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-desktop
    brave
    discord
    firefox
    gimp
    pavucontrol
    nautilus
    spotify
    wl-clipboard
  ];
}
