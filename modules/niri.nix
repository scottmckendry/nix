{
  pkgs,
  username,
  inputs,
  ...
}:
let
  niri-package = inputs.niri-override.packages.${pkgs.stdenv.hostPlatform.system}.niri;
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
  services.udisks2.enable = true;
  security.pam.services.hyprlock.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = username;
      };
    };
  };
}
