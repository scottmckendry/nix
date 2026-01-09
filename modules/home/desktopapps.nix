{ pkgs, inputs, ... }:
let
  zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.generic;
in
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
    zen-browser
  ];
}
