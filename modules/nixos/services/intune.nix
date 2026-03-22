{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.services.intune;
in
{
  # NOTE: Initial registration only seems to work on GNOME.
  options.custom.services.intune = {
    enable = lib.mkEnableOption "Microsoft Intune device management";
  };

  config = lib.mkIf cfg.enable {
    services.intune.enable = true;

    environment.systemPackages = [
      pkgs.glib-networking
    ];

    environment.sessionVariables = {
      SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    };
  };
}
