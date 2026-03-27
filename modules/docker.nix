{ ... }:
{
  den.aspects.docker = {
    nixos = {
      virtualisation.docker.enable = true;
      users.users.scott.extraGroups = [ "docker" ];
    };
  };
}
