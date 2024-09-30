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
    ../../modules/stylix.nix
    ../../modules/work.nix
    ../../modules/locale.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = username;
  networking.hostName = "helios";

  nixpkgs.config.allowUnfree = true;

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

  nix.settings = {
    warn-dirty = false;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  system.stateVersion = "24.05";
}
