{ pkgs, lib, ... }:
{
  stylix = {
    enable = true;
    polarity = "dark";
    image = ../wallpapers/monstera.jpg;
    base16Scheme = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/scottmckendry/cyberdream.nvim/main/extras/base16/cyberdream.yaml";
      sha256 = "1bfi479g7v5cz41d2s0lbjlqmfzaah68cj1065zzsqksx3n63znf";
    };
    opacity.terminal = 0.75;
    cursor.size = 12;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Classic";
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
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = lib.mkForce {
        applications = 10;
        desktop = 10;
        popups = 10;
        terminal = 10;
      };
    };
    targets.chromium.enable = false;
  };
}
