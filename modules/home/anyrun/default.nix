{ pkgs, config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  programs.anyrun = {
    enable = true;
    config = {
      y = {
        fraction = 0.17;
      };
      width = {
        absolute = 420;
      };
      hidePluginInfo = true;
      showResultsImmediately = true;
      plugins = [
        "${pkgs.anyrun}/lib/libapplications.so"
        "${pkgs.anyrun}/lib/libshell.so"
        "${pkgs.anyrun}/lib/librink.so"
      ];
    };

    extraConfigFiles."applications.ron".text = ''
      Config(
        desktop_actions: true,
        terminal: Some(Terminal(
          command: "${pkgs.kitty}/bin/kitty",
          args: "-e {}",
        )),
      )
    '';
  };

  xdg.configFile."anyrun/style.css".source =
    mkOutOfStoreSymlink "${nixDir}/modules/home/anyrun/style.css";
}
