{ ... }:
{
  den.aspects.gnome = {
    nixos =
      { lib, ... }:
      {
        specialisation.gnome.configuration = {
          programs.niri.enable = lib.mkForce false;
          services.greetd.enable = lib.mkForce false;

          services = {
            displayManager.gdm.enable = true;
            desktopManager.gnome.enable = true;
          };
        };
      };
  };
}
