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
}
