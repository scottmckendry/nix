{
  username,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  wsl.enable = true;
  wsl.defaultUser = username;

  custom.services.docker.enable = true;
  custom.services.go.enable = true;
  custom.services.work.enable = true;
}
