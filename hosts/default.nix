{ hostname, ... }:
{
  imports = [
    ../modules
    ./${hostname}/default.nix
  ];
}
