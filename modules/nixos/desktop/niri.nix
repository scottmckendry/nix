{
  config,
  lib,
  pkgs,
  username,
  inputs,
  ...
}:
let
  cfg = config.custom.desktop.niri;
  niri = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
in
{
  imports = [ inputs.niri-flake.nixosModules.niri ];

  options.custom.desktop.niri = {
    enable = lib.mkEnableOption "Niri window manager";
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      package = niri;
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
  };
}
