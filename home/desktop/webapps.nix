{ pkgs, ... }:
let
  prefferedBrowser = pkgs.brave;
  browsercmd = "${prefferedBrowser}/bin/brave";
in
{
  home.packages = [ prefferedBrowser ];
  xdg.desktopEntries = {
    youtube = {
      name = "YouTube";
      exec = "${browsercmd} --app=https://youtube.com";
      icon = "youtube";
    };
  };
}
