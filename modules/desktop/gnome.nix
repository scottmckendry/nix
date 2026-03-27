{ ... }:
{
  den.aspects.gnome = {
    nixos =
      { ... }:
      {
        services.xserver = {
          enable = true;
          displayManager.gdm.enable = true;
          desktopManager.gnome.enable = true;
        };
      };
  };
}
