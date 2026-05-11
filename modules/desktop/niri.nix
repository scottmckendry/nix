{ ... }:
{
  den.aspects.niri = {
    nixos =
      { pkgs, ... }:
      {
        programs.niri.enable = true;
        environment.systemPackages = [ pkgs.xwayland-satellite ];
        services.upower.enable = true;
        services.udisks2.enable = true;

        programs.uwsm = {
          enable = true;
          waylandCompositors.niri = {
            prettyName = "Niri";
            comment = "Niri compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/niri-session";
          };
        };

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "${pkgs.tuigreet}/bin/tuigreet --time --remember";
              user = "greeter";
            };
            initial_session = {
              command = "${pkgs.uwsm}/bin/uwsm start -- niri-uwsm.desktop";
              user = "scott";
            };
          };
        };
      };
  };
}
