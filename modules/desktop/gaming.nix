{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.custom.desktop.gaming;
in
{
  options.custom.desktop.gaming = {
    enable = lib.mkEnableOption "gaming setup with Steam and related tools";
  };

  config = lib.mkIf cfg.enable {
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;
    hardware.xpadneo.enable = true;

    environment.systemPackages = with pkgs; [
      lutris
      mangohud
      prismlauncher
      protonup-ng
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${username}/.steam/root/compatibilitytools.d/";
    };
  };
}
