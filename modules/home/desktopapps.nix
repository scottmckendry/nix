{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-desktop
    brave
    discord
    firefox
    gimp
    libnotify
    nautilus
    pavucontrol
    spotify
    wl-clipboard
  ];
}
