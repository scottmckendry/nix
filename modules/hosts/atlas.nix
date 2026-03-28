{ den, ... }:
{
  den.aspects.atlas = {
    includes = with den.aspects; [
      core
      networking
      silent-boot
      niri
      niri-session
      nvidia
      gaming
      docker
      go
      work
      work-desktop
      swap
    ];

    provides.to-users =
      { host, ... }:
      {
        homeManager.imports = [ ../../home/desktop ];
        homeManager.programs.hyprlock.settings.input-field.monitor = host.output or "";
        homeManager.programs.hyprlock.settings.label.monitor = host.output or "";
      };

    nixos =
      { ... }:
      {
        imports = [
          ./_atlas-hardware.nix
        ];
      };
  };
}
