{ den, ... }:
{
  den.aspects.atlas = {
    includes = with den.aspects; [
      core
      docker
      gaming
      gnome
      networking
      niri
      niri-session
      nvidia
      packages
      silent-boot
      work
      zsh
    ];

    nixos =
      { ... }:
      {
        imports = [
          ./_atlas-hardware.nix
        ];
      };
  };
}
