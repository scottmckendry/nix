# Minimal recursive module importer.
# Imports every *.nix file under dir, except files/dirs prefixed with "_"
dir:
let
  walk =
    d:
    let
      entries = builtins.readDir d;
      names = builtins.attrNames entries;
      files = builtins.filter (
        n:
        entries.${n} == "regular" && builtins.match ".*\\.nix" n != null && builtins.match "_.*" n == null
      ) names;
      dirs = builtins.filter (n: entries.${n} == "directory" && builtins.match "_.*" n == null) names;
    in
    map (n: d + "/${n}") files ++ builtins.concatMap (n: walk (d + "/${n}")) dirs;
in
{
  imports = walk dir;
}
