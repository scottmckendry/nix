{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix/";
in
{
  # Copy cliphist script to config directory
  xdg.configFile."rofi/rofi-cliphist.sh".source = mkOutOfStoreSymlink "${nixDir}rofi/rofi-cliphist.sh";

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "drun";
      font = "Ubuntu Nerd Font 11";
      sidebar-mode = true;
      show-icons = true;
      hide-scrollbar = true;
      display-drun = "  ";
      display-clipboard = "󱛣  ";
      drun-display-format = "{name}";
    };

    theme =
      let inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          theme-black = mkLiteral "#16181a";
          theme-white = mkLiteral "#ffffff";
          theme-grey = mkLiteral "#3c4848";
          theme-blue = mkLiteral "#5ea1ff";
          theme-cyan = mkLiteral "#5ef1ff";
          window-background = mkLiteral "rgba(22, 24, 26, 0.9)";
          foreground = mkLiteral "@theme-blue";
          backlight = mkLiteral "#ccffeedd";
          background-color = mkLiteral "transparent";
          highlight = mkLiteral "underline bold #ffffff";
          transparent = mkLiteral "rgba(46,52,64,0)";
        };

        "window" = {
          width = mkLiteral "500px";
          location = mkLiteral "center";
          anchor = mkLiteral "center";
          border = mkLiteral "0px";
          border-radius = mkLiteral "6px";
          background-color = mkLiteral "@transparent";
          spacing = mkLiteral "0";
          children = mkLiteral "[mainbox]";
          orientation = mkLiteral "horizontal";
        };

        "mainbox" = {
          spacing = mkLiteral "0";
          children = mkLiteral "[inputbar, message, listview]";
        };

        "message" = {
          color = mkLiteral "@theme-black";
          padding = mkLiteral "5";
          border-color = mkLiteral "@foreground";
          border = mkLiteral "0px 2px 2px 2px";
          background-color = mkLiteral "@theme-blue";
        };

        "inputbar" = {
          color = mkLiteral "@theme-white";
          padding = mkLiteral "11px";
          background-color = mkLiteral "@window-background";
          # border = mkLiteral "1px";
          border-radius = mkLiteral "6px 6px 0px 0px";
          # border-color = mkLiteral "@theme-grey";
        };

        "prompt" = {
          color = mkLiteral "@theme-cyan";
        };

        "entry, prompt, case-indicator" = {
          text-font = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        "listview" = {
          padding = mkLiteral "8px";
          border-radius = mkLiteral "0px 0px 6px 6px";
          # border-color = mkLiteral "@theme-grey";
          # border = mkLiteral "0px 1px 1px 1px";
          background-color = mkLiteral "@window-background";
          dynamic = mkLiteral "false";
        };

        "element" = {
          padding = mkLiteral "3px";
          vertical-align = mkLiteral "0.5";
          border-radius = mkLiteral "4px";
          background-color = mkLiteral "transparent";
          color = mkLiteral "@foreground";
          text-color = mkLiteral "rgb(216, 222, 233)";
        };

        "element selected.normal" = {
          background-color = mkLiteral "@theme-grey";
          color = mkLiteral "@theme-cyan";
        };

        "element-text, element-icon" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        "element-icon" = {
          margin = mkLiteral "0px 5px 0px 0px";
        };

        "button" = {
          padding = mkLiteral "6px";
          color = mkLiteral "@foreground";
          horizontal-align = mkLiteral "0.5";
          border = mkLiteral "2px 0px 2px 2px";
          border-radius = mkLiteral "4px 0px 0px 4px";
          border-color = mkLiteral "@foreground";
        };

        "button selected normal" = {
          border = mkLiteral "2px 0px 2px 2px";
          border-color = mkLiteral "@foreground";
        };
      };
  };
}
