{ inputs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "cyberdream";
    };
    themes = {
      cyberdream = {
        src = inputs.cyberdream.extras.textmate;
        file = "cyberdream.tmTheme";
      };
    };
  };
}
