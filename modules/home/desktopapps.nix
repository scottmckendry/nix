{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-desktop
    gimp
    libnotify
    mangohud
    nautilus
    pavucontrol
    prismlauncher
    spotify
    vesktop
  ];
}
