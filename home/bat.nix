{ cyberdream, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "cyberdream";
    };
    themes = {
      cyberdream = {
        src = cyberdream;
        file = "extras/textmate/cyberdream.tmTheme";
      };
    };
  };
}
