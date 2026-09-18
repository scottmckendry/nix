{ ... }:
{
  den.aspects.gnome = {
    nixos =
      { ... }:
      {
        services.desktopManager.gnome.enable = true;
      };
  };
}
