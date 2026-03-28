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
          openssh.authorizedKeys.keyFiles = [
            (pkgs.fetchurl {
              url = "https://github.com/scottmckendry.keys";
              sha256 = "EF8jlfRIzg+pEqPkCq9HYB/niYksYUYfCoHxaxs6C/U=";
            })
          ];
        };
      };

    homeManager =
      { ... }:
      {
        imports = [ ../home ];
      };
  };
}
