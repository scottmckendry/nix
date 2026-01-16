{ desktop, ... }:
{
  imports =
    if desktop then
      [
        ./defaultapps.nix
        ./desktopapps.nix
        ./gtk.nix
        ./niri
        ./webapps.nix
        ../terminal
      ]
    else
      [ ];
}
