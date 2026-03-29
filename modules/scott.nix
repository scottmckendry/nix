{ ... }:
{
  den.aspects.scott = {
    nixos =
      { pkgs, ... }:
      {
        users.users.scott = {
          isNormalUser = true;
          shell = pkgs.zsh;
          description = "Scott McKendry";
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
        };
      };
  };
}
