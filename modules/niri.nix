{
  pkgs,
  lib,
  ...
}:

{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # See https://github.com/YaLTeR/niri/wiki/Xwayland
  environment.systemPackages = [
    pkgs.xwayland-satellite
  ];

  services.greetd = {
    enable = true;
    vt = 7;
    settings = {
      default_session = {
        command = "${lib.getExe' pkgs.niri "niri-session"}";
        user = "scott";
      };
    };
  };
}
