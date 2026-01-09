{ ... }:
{
  imports = [
    ./nixos/boot/silent-boot.nix
    ./nixos/core/core.nix
    ./nixos/core/users.nix
    ./nixos/desktop/gaming.nix
    ./nixos/desktop/niri.nix
    ./nixos/desktop/nvidia.nix
    ./nixos/services/docker.nix
    ./nixos/services/go.nix
    ./nixos/services/networking.nix
    ./nixos/services/virtualisation.nix
    ./nixos/services/work.nix
  ];
}
