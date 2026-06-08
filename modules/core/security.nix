{ ... }:
{
  den.aspects.core = {
    nixos =
      { config, pkgs, ... }:
      {
        security.pam = {
          u2f.settings.cue = true;
          u2f.settings.authfile = config.sops.secrets.u2f_keys_txt.path;
          services = {
            login.u2fAuth = true;
            sudo.u2fAuth = true;
            su.u2fAuth = true;
            hyprlock.u2fAuth = true;
            hyprlock.enableGnomeKeyring = true;
            greetd.enableGnomeKeyring = true;
            tuigreet.enableGnomeKeyring = true;
          };
        };

        # autolock device on u2f key removal
        services.udev.extraRules = ''
          # trustkey
          ACTION=="remove", \
          ENV{ID_BUS}=="usb", \
          ENV{ID_VENDOR_ID}=="311f", \
          ENV{ID_MODEL_ID}=="a7f9", \
          RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"

          # yubikey
          ACTION=="remove", \
          ENV{ID_BUS}=="usb", \
          ENV{ID_VENDOR_ID}=="1050", \
          ENV{ID_MODEL_ID}=="0406", \
          RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
        '';
      };
  };
}
