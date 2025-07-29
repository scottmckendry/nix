{
  pkgs,
  lib,
  ...
}:

{
  programs.niri = {
    enable = true;
  };

  # See https://github.com/YaLTeR/niri/wiki/Xwayland
  environment.systemPackages = with pkgs; [
    pipewire
    xdg-desktop-portal-gnome
    xwayland-satellite
    swaylock
  ];

  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service
  security.pam.services.swaylock = { };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.greetd = {
    enable = true;
    vt = 7;
    settings = {
      default_session = {
        command = "${lib.getExe' pkgs.niri "niri-session"}";
        user = "scott";
      };
    };
  };
}
