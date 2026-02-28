{ pkgs, inputs, ... }:
let
  zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = with pkgs; [
    bitwarden-desktop
    discord
    gimp
    libnotify
    mangohud
    nautilus
    obs-studio
    pavucontrol
    prismlauncher
    spotify
    vlc
    zen-browser
  ];
}
