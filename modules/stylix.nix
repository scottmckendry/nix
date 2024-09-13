{ pkgs, lib, ... }:
{
  stylix = {
    enable = true;
    image = ../wallpapers/grass.png;
    base16Scheme = ./cyberdream.yaml;
    opacity.terminal = 0.9;
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrains Mono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = lib.mkForce {
        applications = 12;
        desktop = 12;
        popups = 12;
        terminal = 10;
      };
    };
  };
}
