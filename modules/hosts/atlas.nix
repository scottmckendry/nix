{ den, ... }:
{
  den.aspects.atlas = {
    includes = with den.aspects; [
      core
      docker
      gaming
      networking
      niri
      niri-session
      nvidia
      packages
      silent-boot
      swap
      work
      work-desktop
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
