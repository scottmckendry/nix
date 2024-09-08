# Contains all the configuration for hyprland, swayidle, swaylock, etc.
{ config, pkgs, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix/";
in
{
  # Create symlinks to the config files - this enables hot reloading
  xdg.configFile."hypr/hyprland.conf".source = mkOutOfStoreSymlink "${nixDir}/hyprland/hyprland.conf";

  home.packages = with pkgs; [
    swayidle
  ];

  programs.swaylock = {
    enable = true;
    # This fork is more stable than the one available in nixpkgs - fixes red screen of death
    package = pkgs.swaylock-effects.overrideAttrs
      (_: {
        src = pkgs.fetchFromGitHub {
          owner = "jirutka";
          repo = "swaylock-effects";
          rev = "v1.7.0.0";
          sha256 = "cuFM+cbUmGfI1EZu7zOsQUj4rA4Uc4nUXcvIfttf9zE=";
        };
      });
    settings = {
      screenshots = true;
      indicator = true;
      indicator-radius = 120;
      font = "JetBrains Mono Nerd Font";
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      fade-in = 0.2;

      clock = true;
      timestr = "%I:%M:%S %p";
      datestr = "%a, %d %b %Y";

      # colors
      text-color = "#ffffff";
      text-clear-color = "#ffffff";
      text-ver-color = "#5ef1ff";
      text-wrong-color = "#ff6e5e";

      ring-color = "#00000000";
      key-hl-color = "#00000000";
      bs-hl-color = "#00000000";
      line-color = "#00000000";
      inside-color = "#00000000";
      separator-color = "#00000000";

      inside-clear-color = "#00000000";
      line-clear-color = "#00000000";
      ring-clear-color = "#00000000";

      inside-ver-color = "#00000000";
      line-ver-color = "#00000000";
      ring-ver-color = "#00000000";

      inside-wrong-color = "#00000000";
      line-wrong-color = "#00000000";
      ring-wrong-color = "#00000000";
    };
  };
}
