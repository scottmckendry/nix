{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = [ pkgs.posting ];

  xdg.configFile."posting/config.yaml".text = lib.generators.toYAML { } {
    theme = "cyberdream";
    theme_directory = "${config.xdg.configHome}/posting/themes";
  };

  xdg.configFile."posting/themes/cyberdream.yaml".text = lib.generators.toYAML { } {
    name = "cyberdream";
    primary = "#bd5eff";
    secondary = "#5ea1ff";
    accent = "#5ef1ff";
    background = "#16181a";
    surface = "#3c4048";
    error = "#ff6e5e";
    success = "#5eff6c";
    warning = "#ffbd5e";

    author = "Scott McKendry";
    homepage = "https://gitub.com/scottmckendry/cyberdream.nvim";
  };
}
