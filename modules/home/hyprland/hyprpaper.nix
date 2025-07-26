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
      preload = [ "${config.home.homeDirectory}/Pictures/Wallpapers/sunset.png" ];
      wallpaper = [ ",${config.home.homeDirectory}/Pictures/Wallpapers/sunset.png" ];
    };
  };
}
