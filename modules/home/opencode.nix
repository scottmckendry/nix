{ inputs, ... }:
let
  pinnedPackage = inputs.nixpkgs-opencode.legacyPackages.${"x86_64-linux"}.opencode;
in
{
  home.packages = [ pinnedPackage ];
  home.file.".config/opencode/config.json".text = ''
    {
      "$schema": "https://opencode.ai/config.json",
      "theme": "system",
      "autoupdate": false
    }
  '';
}
