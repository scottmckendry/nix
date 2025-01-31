{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brave
    dolphin
    firefox
    gimp
    konversation
    spotify
    vesktop
    wl-clipboard
  ];
}
