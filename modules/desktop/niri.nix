{ inputs, ... }:
{
  den.aspects.niri = {
    nixos =
      { pkgs, ... }:
      {
        programs.niri = {
          package = inputs.nix-cache.packages.${pkgs.stdenv.hostPlatform.system}.niri;
          enable = true;
        };

        environment.systemPackages = [ pkgs.xwayland-satellite ];

        services.upower.enable = true;
        services.udisks2.enable = true;
        security.pam.services.hyprlock.enableGnomeKeyring = true;
        security.pam.services.greetd.enableGnomeKeyring = true;

        services.greetd = {
          enable = true;
          settings.default_session = {
            command = "${pkgs.niri}/bin/niri-session";
            user = "scott";
          };
        };
      };
  };
}
