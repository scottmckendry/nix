{ config, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${config.stylix.image}" ];
      wallpaper = [ ",${config.stylix.image}" ];
    };
  };
}
