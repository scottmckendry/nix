{ pkgs, ... }:

{
  home.packages = [ pkgs.opencode ];
  home.file.".config/opencode/config.json".text = ''
    {
      "$schema": "https://opencode.ai/config.json",
      "theme": "system",
      "autoupdate": false
    }
  '';
}
