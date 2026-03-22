let
  # Dynamically import all overlay files in this directory
  overlayFiles = builtins.filter (
    name: name != "default.nix" && builtins.match ".*\\.nix" name != null
  ) (builtins.attrNames (builtins.readDir ./.));
in
# Return a list of overlays for composeManyExtensions
builtins.map (file: import (./. + "/${file}")) overlayFiles
