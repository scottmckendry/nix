{ lib, den, ... }:
{
  den.aspects.gtk = {
    includes = [ den.aspects.nautilus ];

    nixos =
      { pkgs, ... }:
      let
        nightfox = pkgs.nightfox-gtk-theme.override {
          colorVariants = [ "dark" ];
          tweakVariants = [ "carbonfox" ];
        };
      in
      {
        environment.systemPackages = with pkgs; [
          adwaita-icon-theme
          bibata-cursors
          nightfox
          tela-icon-theme
        ];

        programs.dconf.profiles.user.databases = [
          {
            settings."org/gnome/desktop/interface" = {
              gtk-theme = "Nightfox-Dark-Carbonfox";
              icon-theme = "Tela-dracula-dark";
              cursor-theme = "Bibata-Modern-Classic";
              cursor-size = lib.gvariant.mkInt32 16;
            };
          }
        ];
      };
  };
}
