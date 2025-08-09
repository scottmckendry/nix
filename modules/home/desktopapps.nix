{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-desktop
    brave
    discord
    firefox
    gimp
    google-fonts
    libnotify
    nautilus
    pavucontrol
    spotify
    wl-clipboard
  ];
}
