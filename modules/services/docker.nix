{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.custom.services.docker;
in
{
  options.custom.services.docker = {
    enable = lib.mkEnableOption "Docker virtualization";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.${username}.extraGroups = [ "docker" ];
  };
}
