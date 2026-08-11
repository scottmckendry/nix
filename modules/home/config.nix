{ inputs, utils, ... }:
let
  thm = inputs.cyberdream.extras;
  nixDir = "/home/scott/git/nix";
in
{
  den.aspects.scott = {
    hjem =
      { pkgs, ... }:
      let
        mkSym = utils.mkSymlink pkgs;
      in
      {
        files = {
          ".config/bat/config".source = ../../home/bat/config;
          ".config/btop/btop.conf".source = ../../home/btop/btop.conf;
          ".config/git/config".source = ../../home/git/config;
          ".config/k9s/aliases.yaml".source = ../../home/k9s/aliases.yaml;
          ".config/k9s/config.yaml".source = ../../home/k9s/config.yaml;
          ".config/kitty/kitty.conf".source = ../../home/kitty/kitty.conf;
          ".config/lazygit/config.yml".source = ../../home/lazygit/config.yml;
          ".config/mimeapps.list".source = ../../home/mimeapps.list;
          ".local/share/applications/mimeapps.list".source = ../../home/mimeapps.list;
          ".config/posting/config.yaml".source = ../../home/posting/config.yaml;
          ".config/starship.toml".source = ../../home/starship.toml;
          ".config/user-dirs.dirs".source = ../../home/user-dirs.dirs;
          ".config/yazi/yazi.toml".source = ../../home/yazi/yazi.toml;

          # symlinks
          ".config/DankMaterialShell".source = mkSym "${nixDir}/home/dms";
          ".config/DankMaterialShell/plugins/nixUpdates".source = mkSym "${nixDir}/home/dms/nixUpdates";
          ".config/niri".source = mkSym "${nixDir}/home/niri";
          ".config/nvim".source = mkSym "${nixDir}/nvim";
          ".pi".source = mkSym "${nixDir}/home/pi";
          "scripts".source = mkSym "${nixDir}/scripts";

          # cyberdream themes
          ".pi/agent/themes/cyberdream-muted.json".source = "${thm.pi}/cyberdream-muted.json";
          ".config/bat/themes/cyberdream.tmTheme".source = "${thm.textmate}/cyberdream-muted.tmTheme";
          ".config/btop/themes/cyberdream.theme".source = "${thm.btop}/cyberdream-muted.theme";
          ".config/k9s/skins/cyberdream.yaml".source = "${thm.k9s}/cyberdream-muted.yml";
          ".config/kitty/theme.conf".source = "${thm.kitty}/cyberdream-muted.conf";
          ".config/opencode/themes/cyberdream.json".source = "${thm.opencode}/cyberdream-muted.json";
          ".config/posting/themes/cyberdream.yaml".source = "${thm.posting}/cyberdream-muted.yaml";
          ".config/yazi/theme.toml".source = "${thm.yazi}/cyberdream-muted.toml";
        };
      };
  };
}
