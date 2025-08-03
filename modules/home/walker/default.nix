{ inputs, ... }:
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

  # HACK: out-of-store symlinks don't work, and neither do in-store ones. This is a workaround
  # to fix the "fork/exec ... permission denied" error when trying to run walker plugins.
  home.activation.walkerPlugins = ''
    rm -rf ~/.config/walker/plugins
    mkdir -p ~/.config/walker/plugins
    cp -r ${./plugins}/* ~/.config/walker/plugins/ 
    chmod -R 755 ~/.config/walker/plugins
  '';
}
