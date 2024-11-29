{ ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      hide_window_decorations = "titlebar-only";
      window_padding_width = 10;
      window_padding_height = 10;
      cursor_trail = 3;
    };
  };
}
