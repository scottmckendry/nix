{ inputs, ... }:
{
  den.aspects.core = {
    nixos =
      { config, ... }:
      {
        imports = [ inputs.sops-nix.nixosModules.sops ];

        sops = {
          defaultSopsFile = ../../secrets/u2f.secret.sops.yaml;
          age.keyFile = "/var/lib/sops-nix/key.txt";
          secrets.u2f_keys = {
            owner = config.users.users.scott.name;
            path = "/home/scott/.config/Yubico/u2f_keys";
          };
        };

        security.pam = {
          u2f.settings.authfile = config.sops.secrets.u2f_keys.path;
          services = {
            login.u2fAuth = true;
            sudo.u2fAuth = true;
            su.u2fAuth = true;
            hyprlock.u2fAuth = true;
            hyprlock.enableGnomeKeyring = true;
            greetd.enableGnomeKeyring = true;
          };
        };
      };
  };
}
