{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-desktop
    brave
    gimp
    libnotify
    nautilus
    pavucontrol
    spotify
    vesktop
    wl-clipboard
  ];
}
