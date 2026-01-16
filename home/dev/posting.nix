{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.posting ];

  xdg.configFile."posting/config.yaml".text = lib.generators.toYAML { } {
    theme = "cyberdream";
    theme_directory = "${config.xdg.configHome}/posting/themes";
  };

  xdg.configFile."posting/themes/cyberdream.yaml".source =
    "${inputs.cyberdream}/extras/posting/cyberdream.yaml";
}
