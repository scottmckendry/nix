{ pkgs, ... }:

{
  gtk.enable = true;
  gtk.iconTheme.package = pkgs.papirus-icon-theme;
  gtk.iconTheme.name = "Papirus-Dark";
}
