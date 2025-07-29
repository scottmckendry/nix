{
  inputs,
  config,
  pkgs,
  ...
}:

{
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.system}.hyprpaper;

    settings = {
      preload = [ "${config.home.homeDirectory}/Pictures/Wallpapers/ship.jpg" ];
      wallpaper = [ ",${config.home.homeDirectory}/Pictures/Wallpapers/ship.jpg" ];
    };
  };
}
