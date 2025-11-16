{ pkgs, ... }:
{
  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-termfilechooser
      ];
      config = {
        common.default = [
          "termfilechooser"
          "gtk"
        ];
        niri = {
          default = [
            "termfilechooser"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
      };
    };

    configFile = {
      "xdg-desktop-portal-termfilechooser/config" = {
        text = ''
          [filechooser]
          cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
          env=TERMCMD=foot -a yazi-float
        '';
      };
    };
  };
}
