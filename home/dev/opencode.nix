{ inputs, ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      theme = "cyberdream";
      autoupdate = false;
    };
  };
  xdg.configFile."opencode/themes/cyberdream.json".source =
    "${inputs.cyberdream}/extras/opencode/cyberdream.json";
}
