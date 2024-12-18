{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };

    settings = {
      hide_window_decorations = "titlebar-only";
      window_padding_width = 10;
      window_padding_height = 10;
      cursor_trail = 3;

      font_size = 10;
      background_opacity = 0.75;

      # Cyberdream theme colors
      background = "#16181a";
      foreground = "#ffffff";
      cursor = "#ffffff";
      cursor_text_color = "#16181a";
      selection_background = "#3c4048";
      selection_foreground = "#ffffff";

      color0 = "#16181a";
      color1 = "#ff6e5e";
      color2 = "#5eff6c";
      color3 = "#f1ff5e";
      color4 = "#5ea1ff";
      color5 = "#bd5eff";
      color6 = "#5ef1ff";
      color7 = "#ffffff";

      color8 = "#3c4048";
      color9 = "#ff6e5e";
      color10 = "#5eff6c";
      color11 = "#f1ff5e";
      color12 = "#5ea1ff";
      color13 = "#bd5eff";
      color14 = "#5ef1ff";
      color15 = "#ffffff";
    };
  };

  stylix.targets = {
    kitty.enable = false;
  };
}