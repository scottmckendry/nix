{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-desktop
    brave
    firefox
    gimp
    google-fonts
    libnotify
    nautilus
    pavucontrol
    spotify
    vesktop
    wl-clipboard
  ];
}
