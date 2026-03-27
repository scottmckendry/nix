{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.desktop.gnome;
in
{
  options.custom.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
