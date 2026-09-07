{ ... }:
{
  # NOTE: Initial registration only seems to work on GNOME.
  den.aspects.intune = {
    nixos =
      { pkgs, config, ... }:
      let
        pwquality = unixRule: {
          control = "requisite";
          modulePath = "${pkgs.libpwquality}/lib/security/pam_pwquality.so";
          order = unixRule.order - 50;
          settings = {
            minlen = 16;
            dcredit = -1; # at least 1 digit
            ucredit = -1; # at least 1 uppercase
            lcredit = -1; # at least 1 lowercase
            ocredit = -1; # at least 1 symbol
          };
        };
      in
      {
        services.intune.enable = true;

        # Upstream module installs units but does not enable them.
        systemd.sockets.intune-daemon.wantedBy = [ "sockets.target" ];
        systemd.user.timers.intune-agent.wantedBy = [ "graphical-session.target" ];

        environment.systemPackages = [ pkgs.glib-networking ];

        environment.sessionVariables = {
          SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
        };

        # Intune only inspects common-password, system-password, and password-auth.
        # NixOS applies password rules via passwd, so expose same policy at first path.
        security.pam.services = {
          passwd.rules.password.pwquality = pwquality config.security.pam.services.passwd.rules.password.unix;
          "common-password".rules.password.pwquality =
            pwquality
              config.security.pam.services."common-password".rules.password.unix;
        };
      };
  };
}
