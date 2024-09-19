{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/locale.nix
    ./modules/networking.nix
    ./modules/nvidia.nix
    ./modules/stylix.nix
    ./modules/gaming.nix
    ./modules/work.nix
  ];

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable dynamically link binaries.
  programs.nix-ld.enable = true;

  # Create user account.
  users.users.scott = {
    isNormalUser = true;
    description = "Scott McKendry";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  system.stateVersion = "24.05";
}
