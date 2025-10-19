{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-desktop
    brave
    firefox
    gimp
    libnotify
    nautilus
    pavucontrol
    spotify
    vesktop
    wl-clipboard
  ];
}
