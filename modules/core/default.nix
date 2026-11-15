{ den, ... }:
{
  den.aspects.core.includes = with den.aspects; [
    fleet
    boot
    security
    swap
    luks
    flakemill
    nix-settings
    locale
    fonts
    hjem
  ];
}
