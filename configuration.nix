{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/locale.nix
    ./modules/networking.nix
    ./modules/nvidia.nix
    ./modules/stylix.nix
    ./modules/gaming.nix
    ./modules/gnome.nix
    ./modules/work.nix
  ];

  # bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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
