{
  username,
  hostname,
  inputs,
  lib,
  ...
}:

{
  imports = [ inputs.nixos-wsl.nixosModules.default ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  wsl.enable = true;
  wsl.defaultUser = username;
  networking.hostName = hostname;
}
