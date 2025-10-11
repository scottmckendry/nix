{ inputs, config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  imports = [ inputs.walker.homeManagerModules.default ];

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      force_keyboard_focus = true;
      close_when_open = true;
      selection_wrap = true;
      click_to_close = true;
      theme = "cyberdream";

      placeholders.default = {
        input = "Search...";
        list = "No Results";
      };

      keybinds = {
        quick_activate = [ ];
      };
    };
  };

  xdg.configFile."elephant/websearch.toml".text = ''
    engines_as_actions = true

    [[entries]]
    default = true
    name = "DuckDuckGo"
    url = "https://www.duckduckgo.com/?q=%TERM%"
  '';

  xdg.configFile."walker/themes/cyberdream".source =
    mkOutOfStoreSymlink "${nixDir}/modules/home/walker/theme";
}
