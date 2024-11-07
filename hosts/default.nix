{
  pkgs,
  pkgs-stable,
  hostname,
  username,
  inputs,
  name,
  desktop,
  ...
}:

{
  imports = [
    ./${hostname}/default.nix
    ../modules/docker.nix
    ../modules/locale.nix
    ../modules/rust.nix
    ../modules/stylix.nix
    ../modules/work.nix
  ];

  nix.settings = {
    warn-dirty = false;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

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
      imports = [ ../modules/home ];
    };

    extraSpecialArgs = {
      inherit inputs;
      inherit username;
      inherit hostname;
      inherit desktop;
      inherit pkgs-stable;
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
