{ pkgs, inputs, ... }:
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
    };
  };

  home.packages = with pkgs; [
    libqalculate
    lua
  ];

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
