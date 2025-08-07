{
  pkgs,
  inputs,
  config,
  ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      search.placeholder = "Search...";
      ui.fullscreen = true;
      websearch.prefix = "?";
      switcher.prefix = "/";
      theme = "cyberdream";
      terminal = "kitty";
    };
  };

  home.packages = with pkgs; [
    libqalculate
    lua
  ];

  xdg.configFile."walker/themes".source = mkOutOfStoreSymlink "${nixDir}/modules/home/walker/themes";

  # Create stubs for custom plugins.
  home.activation.walkerPlugins = ''
    rm -rf ~/.config/walker/plugins
    mkdir -p ~/.config/walker/plugins
    for plugin in ~/git/nix/modules/home/walker/plugins/*.lua; do
      name=$(basename "$plugin")
      echo "return dofile(\"$plugin\")" > ~/.config/walker/plugins/"$name"
    done
    chmod -R 755 ~/.config/walker/plugins
  '';
}
