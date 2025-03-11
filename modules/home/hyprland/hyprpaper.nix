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
      preload = [ "${config.home.homeDirectory}/Pictures/Wallpapers/mountain.png" ];
      wallpaper = [ ",${config.home.homeDirectory}/Pictures/Wallpapers/mountain.png" ];
    };
  };
}
