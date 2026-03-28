{ inputs, lib, ... }:
let
  sourceFiles = [
    "foot/foot.ini"
    "git/config"
    "k9s/config.yaml"
    "k9s/aliases.yaml"
    "kitty/kitty.conf"
    "lazygit/config.yml"
    "opencode/opencode.json"
    "opencode/tui.json"
    "posting/config.yaml"
  ];
in
{
  xdg.configFile =
    lib.listToAttrs (
      map (f: {
        name = f;
        value.source = ./. + "/.config/${f}";
      }) sourceFiles
    )
    // {
      # cyberdream theme files
      "foot/theme.ini".source = "${inputs.cyberdream.extras.foot}/cyberdream.ini";
      "k9s/skins/cyberdream.yaml".source = "${inputs.cyberdream.extras.k9s}/cyberdream.yml";
      "kitty/theme.conf".source = "${inputs.cyberdream.extras.kitty}/cyberdream.conf";
      "opencode/themes/cyberdream.json".source = "${inputs.cyberdream.extras.opencode}/cyberdream.json";
      "posting/themes/cyberdream.yaml".source = "${inputs.cyberdream.extras.posting}/cyberdream.yaml";
    };
}
