{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    discord
    dolphin
    firefox
    gimp
    konversation
    spotify
    wl-clipboard
  ];
}
