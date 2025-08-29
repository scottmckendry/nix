{
  pkgs,
  username,
  inputs,
  ...
}:
let
  niri-package = inputs.niri-override.packages.${pkgs.system}.niri;
in
{
  programs.niri = {
    package = niri-package;
    enable = true;
  };

  environment.systemPackages = [ pkgs.xwayland-satellite ];
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.upower.enable = true;
  security.pam.services.hyprlock.enableGnomeKeyring = true;

  services.displayManager = {
    gdm = {
      enable = true;
    };
    autoLogin.enable = true;
    autoLogin.user = username;
  };
}
