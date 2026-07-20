{ inputs, lib, ... }:
{
  den.aspects.niri = {
    nixos =
      { pkgs, ... }:
      {
        imports = [
          inputs.dms.nixosModules.dank-material-shell
          inputs.dms-greeter.nixosModules.default
        ];

        programs.niri.enable = lib.mkForce true;
        environment.systemPackages = [ pkgs.xwayland-satellite ];
        services.upower.enable = true;
        services.udisks2.enable = true;
        services.greetd.settings.default_session.user = "scott";

        programs.dank-material-shell.enable = true;
        programs.dank-material-shell.systemd.enable = true;
        programs.dms-greeter = {
          enable = true;
          compositor.name = "niri";
          configHome = "/home/scott";
          compositor.customConfig = ''
            output "DP-1" {
                mode      "3440x1440@144"
                scale     1
                transform "normal"
                position  x=0 y=0
                focus-at-startup
            }
            output "eDP-1" {
                mode      "2400x1600@120"
                scale     1.2
                variable-refresh-rate
                position  x=920 y=1080
            }
            output "HDMI-A-1" { off; }
            output "DVI-I-1" { off; }
            output "DP-5" { off; }
            output "DP-6" { off; }
            hotkey-overlay { skip-at-startup; }
            overview { backdrop-color "#000000"; }
            cursor {
                xcursor-theme "Bibata-Modern-Classic"
                xcursor-size 16
            }
          '';
        };

        programs.uwsm = {
          enable = true;
          waylandCompositors.niri = {
            prettyName = "Niri";
            comment = "Niri compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/niri-session";
          };
        };
      };
  };
}
