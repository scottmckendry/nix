{
  pkgs,
  username,
  inputs,
  hostname,
  desktop,
  ...
}:
{
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Scott McKendry";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  home-manager = {
    useUserPackages = true;

    users.${username} = {
      imports = [ ../../../home ];
    };

    extraSpecialArgs = {
      inherit
        inputs
        username
        hostname
        desktop
        ;
    };
  };
}
