{ inputs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
    };

    settings = {
      # Text
      font_size = 10;
      adjust_line_height = "115%";
      cursor_trail = 3;

      # Window appearance
      window_border_width = 0;
      hide_window_decorations = true;
      window_padding_width = 10;
      window_padding_height = 10;
      background_opacity = 0.75;
      tab_bar_style = "powerline";

      # Window behavior
      enabled_layouts = "horizontal";
      focus_follows_mouse = true;
      confirm_os_window_close = 0;
    };

    extraConfig = ''
      include ${inputs.cyberdream.extras.kitty}/cyberdream.conf
    '';
  };
}
