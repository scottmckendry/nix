{ ... }:
{
  # NOTE: Initial registration only seems to work on GNOME.
  den.aspects.intune = {
    nixos =
      { pkgs, ... }:
      {
        services.intune.enable = true;

        environment.systemPackages = [ pkgs.glib-networking ];

        environment.sessionVariables = {
          SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
        };
      };
  };
}
