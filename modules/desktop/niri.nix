{ inputs, ... }:
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

        environment.etc."greetd/start.sh".text = ''
          #!/usr/bin/env bash
          set -e
          ${pkgs.kbd}/bin/setvtrgb ${inputs.cyberdream.extras.setvtrgb}/cyberdream.conf
          ${pkgs.tuigreet}/bin/tuigreet --remember --asterisks \
            --theme 'border=lightblack;text=white;prompt=cyan;action=lightblack;container=black;input=white;title=magenta;'
        '';
        environment.etc."greetd/start.sh".mode = "0755";

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "/etc/greetd/start.sh";
              user = "greeter";
            };
          };
        };
      };
  };
}
