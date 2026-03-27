{ ... }:
{
  imports = [
    ./boot/secure-boot.nix
    ./boot/silent-boot.nix
    ./boot/tpm2-luks.nix
    ./core/core.nix
    ./core/users.nix
    ./desktop/displaylink.nix
    ./desktop/gaming.nix
    ./desktop/gnome.nix
    ./desktop/niri.nix
    ./desktop/nvidia.nix
    ./services/docker.nix
    ./services/go.nix
    ./services/intune.nix
    ./services/networking.nix
    ./services/virtualisation.nix
    ./services/work.nix
  ];
}
