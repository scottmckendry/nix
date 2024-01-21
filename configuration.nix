{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./modules/locale.nix
      ./modules/networking.nix
      ./modules/nvidia.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "nz";
    xkbVariant = "mao";
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "scott";
      lightdm.enable = true;
      defaultSession = "hyprland";
    };
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };

  # Let swaylock use pam
  security.pam.services.swaylock = { };

  #Services
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
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
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Import Home Manager configuration.
  home-manager.users.scott = { pkgs, ... }: {
    imports = [
      ./home.nix
    ];
  };

  # Install system packages.
  environment.systemPackages = with pkgs; [
    vim
  ];

  # System state - do not edit.
  system.stateVersion = "23.11";
}
