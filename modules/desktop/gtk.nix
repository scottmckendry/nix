{ lib, den, ... }:
{
  den.aspects.gtk = {
    includes = [ den.aspects.nautilus ];

    nixos =
      { pkgs, ... }:
      let
        colloid = pkgs.colloid-gtk-theme.override {
          themeVariants = [ "purple" ];
          tweaks = [ "nord" ];
        };
        theme = "Colloid-Purple-Dark-Nord";
      in
      {
        environment.systemPackages = with pkgs; [
          adwaita-icon-theme
          bibata-cursors
          colloid
          tela-icon-theme
        ];

        environment.sessionVariables.GTK_THEME = theme;
        environment.sessionVariables.GTK_USE_PORTAL = "1";
        environment.sessionVariables.XCURSOR_SIZE = "16";

        programs.dconf.profiles.user.databases = [
          {
            settings."org/gnome/desktop/interface" = {
              gtk-theme = theme;
              icon-theme = "Tela-dracula-dark";
              cursor-theme = "Bibata-Modern-Classic";
              cursor-size = lib.gvariant.mkInt32 16;
            };
          }
        ];
      };
  };
}
