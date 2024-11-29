{ ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 10;
        };
        dimensions = {
          columns = 180;
          lines = 45;
        };
      };
    };
  };
}
