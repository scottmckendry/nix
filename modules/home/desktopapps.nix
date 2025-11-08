{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-desktop
    gimp
    libnotify
    nautilus
    pavucontrol
    spotify
    vesktop
    wl-clipboard
  ];
}
