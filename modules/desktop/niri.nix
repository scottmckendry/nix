{ inputs, ... }:
{
  den.aspects.niri = {
    nixos =
      { pkgs, ... }:
      {
        imports = [ inputs.niri-flake.nixosModules.niri ];

        programs.niri = {
          package = inputs.nix-cache.packages.${pkgs.stdenv.hostPlatform.system}.niri;
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
          settings.default_session = {
            command = "${pkgs.niri}/bin/niri-session";
            user = "scott";
          };
        };

        xdg.portal = {
          enable = true;
          xdgOpenUsePortal = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-termfilechooser
            xdg-desktop-portal-gnome
            xdg-desktop-portal-gtk
          ];
          config = {
            common.default = [
              "termfilechooser"
              "gnome"
              "gtk"
            ];
            niri = {
              default = [
                "termfilechooser"
                "gnome"
                "gtk"
              ];
              "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
            };
          };
        };
      };
  };
}
