{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./modules/locale.nix
    ./modules/networking.nix
    ./modules/nvidia.nix
    <home-manager/nixos>
  ];

  # bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

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

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball { config = config.nixpkgs.config; };
    };
  };

  environment.systemPackages = with pkgs; [ unstable.neovim ];

  # Import Home Manager configuration.
  home-manager.users.scott = { pkgs, ... }: { imports = [ ./home.nix ]; };

  system.stateVersion = "24.05";
}
