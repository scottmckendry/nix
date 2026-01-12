{ cyberdream, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=10";
        pad = "10x10";
        initial-window-size-chars = "140x40";
        include = "${cyberdream}/extras/foot/cyberdream.ini";
      };
    };
  };
}
