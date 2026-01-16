{ inputs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "cyberdream";
    };
    themes = {
      cyberdream = {
        src = inputs.cyberdream;
        file = "extras/textmate/cyberdream.tmTheme";
      };
    };
  };
}
