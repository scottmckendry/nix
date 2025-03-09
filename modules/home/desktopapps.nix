{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-desktop
    brave
    discord
    firefox
    gimp
    kdePackages.dolphin
    kdePackages.konversation
    spotify
    wl-clipboard
  ];
}
