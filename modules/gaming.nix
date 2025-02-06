{ pkgs, ... }:
{
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  hardware.xpadneo.enable = true;

  environment.systemPackages = with pkgs; [
    lutris
    mangohud
    prismlauncher
    protonup
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/scott/.steam/root/compatibilitytools.d/";
  };
}
