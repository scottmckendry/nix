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

    provides.to-users =
      { host, ... }:
      let
        monitor = host.output or "";
        hyprlock = builtins.readFile ../../home/.config/hypr/hyprlock.conf;
      in
      {
        homeManager.xdg.configFile."hypr/hyprlock.conf".text =
          builtins.replaceStrings [ "MONITOR" ] [ monitor ]
            hyprlock;
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
