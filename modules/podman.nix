{ ... }:
{
  den.aspects.podman = {
    nixos =
      { host, pkgs, ... }:
      {
        environment = {
          systemPackages = [
            pkgs.podman-compose
            (pkgs.writeShellScriptBin "docker-compose" ''
              exec ${pkgs.podman-compose}/bin/podman-compose "$@"
            '')
          ];
          variables.PODMAN_COMPOSE_PROVIDER = "${pkgs.podman-compose}/bin/podman-compose";
        };

        virtualisation.podman = {
          enable = true;

          dockerCompat = true;
          dockerSocket.enable = true;

          autoPrune = {
            enable = true;
            flags = [
              "--filter=until=7d"
            ];
          };
          defaultNetwork.settings.dns_enabled = true;
        };

        users.users.${host.settings.fleet.primaryUser} = {
          # Subuid/subgid ranges for rootless userns mapping
          subUidRanges = [
            {
              startUid = 100000;
              count = 65536;
            }
          ];
          subGidRanges = [
            {
              startGid = 100000;
              count = 65536;
            }
          ];
        };
      };
  };
}
