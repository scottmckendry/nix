{ ... }:
{
  imports = [
    ./defaultapps.nix
    ./desktopapps.nix
    ./gtk.nix
    ./niri
    ./webapps.nix
    ../terminal
  ];
}
