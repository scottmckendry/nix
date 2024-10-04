{
  pkgs,
  inputs,
  username,
  name,
  desktop,
  ...
}:

{
  imports = [
    ../../modules/gaming.nix
    ../../modules/hyprland.nix
    ../../modules/locale.nix
    ../../modules/networking.nix
    ../../modules/nvidia.nix
    ../../modules/stylix.nix
    ../../modules/work.nix
    ../../modules/virtualisation.nix
    ./hardware-configuration.nix
  ];

  nix.settings = {
    warn-dirty = false;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = name;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username} = {
      imports = [ ../../modules/home ];
    };

    extraSpecialArgs = {
      inherit inputs;
      inherit username;
      inherit desktop;
    };
  };

  programs.nix-ld.enable = true;
  programs.zsh.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
}
