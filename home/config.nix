{
  inputs,
  config,
  ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
  cfg = ./. + "/.config";
in
{
  xdg.configFile = {
    # config files
    "foot/foot.ini".source = cfg + "/foot/foot.ini";
    "git/config".source = cfg + "/git/config";
    "k9s/config.yaml".source = cfg + "/k9s/config.yaml";
    "k9s/aliases.yaml".source = cfg + "/k9s/aliases.yaml";
    "kitty/kitty.conf".source = cfg + "/kitty/kitty.conf";
    "lazygit/config.yml".source = cfg + "/lazygit/config.yml";
    "opencode/opencode.json".source = cfg + "/opencode/opencode.json";
    "opencode/tui.json".source = cfg + "/opencode/tui.json";
    "posting/config.yaml".source = cfg + "/posting/config.yaml";

    # cyberdream theme files
    "foot/theme.ini".source = "${inputs.cyberdream.extras.foot}/cyberdream.ini";
    "k9s/skins/cyberdream.yaml".source = "${inputs.cyberdream.extras.k9s}/cyberdream.yml";
    "kitty/theme.conf".source = "${inputs.cyberdream.extras.kitty}/cyberdream.conf";
    "opencode/themes/cyberdream.json".source = "${inputs.cyberdream.extras.opencode}/cyberdream.json";
    "posting/themes/cyberdream.yaml".source = "${inputs.cyberdream.extras.posting}/cyberdream.yaml";

    # symlinks
    "niri".source = mkOutOfStoreSymlink "${nixDir}/home/desktop/niri/config";
    "waybar".source = mkOutOfStoreSymlink "${nixDir}/home/desktop/waybar";
    "nvim".source = mkOutOfStoreSymlink "${nixDir}/nvim";
  };

  home.file."scripts".source = mkOutOfStoreSymlink "${nixDir}/scripts";
}
