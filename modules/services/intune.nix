{ ... }:
{
  # NOTE: Initial registration only seems to work on GNOME.
  den.aspects.intune = {
    nixos =
      { pkgs, config, ... }:
      {
        services.intune.enable = true;

        environment.systemPackages = [ pkgs.glib-networking ];

        environment.sessionVariables = {
          SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
        };

        security.pam.services.passwd.rules.password = {
          pwquality = {
            control = "requisite";
            modulePath = "${pkgs.libpwquality}/lib/security/pam_pwquality.so";
            order = config.security.pam.services.passwd.rules.password.unix.order - 50;
            settings = {
              minlen = 16;
              dcredit = -1; # at least 1 digit
              ucredit = -1; # at least 1 uppercase
              lcredit = -1; # at least 1 lowercase
              ocredit = -1; # at least 1 symbol
            };
          };
        };
      };
  };
}
