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
          ".config/foot/foot.ini".source = ../../home/foot/foot.ini;
          ".config/git/config".source = ../../home/git/config;
          ".config/gtk-2.0/gtkrc".source = ../../home/gtk-2.0/gtkrc;
          ".config/gtk-3.0/settings.ini".source = ../../home/gtk-3.0/settings.ini;
          ".config/gtk-4.0/settings.ini".source = ../../home/gtk-4.0/settings.ini;
          ".config/k9s/aliases.yaml".source = ../../home/k9s/aliases.yaml;
          ".config/k9s/config.yaml".source = ../../home/k9s/config.yaml;
          ".config/kitty/kitty.conf".source = ../../home/kitty/kitty.conf;
          ".config/lazygit/config.yml".source = ../../home/lazygit/config.yml;
          ".config/mako/config".source = ../../home/mako/config;
          ".config/mimeapps.list".source = ../../home/mimeapps.list;
          ".config/opencode/opencode.json".source = ../../home/opencode/opencode.json;
          ".config/opencode/tui.json".source = ../../home/opencode/tui.json;
          ".config/posting/config.yaml".source = ../../home/posting/config.yaml;
          ".config/starship.toml".source = ../../home/starship.toml;
          ".config/vicinae/settings.json".source = ../../home/vicinae/settings.json;
          ".config/yazi/yazi.toml".source = ../../home/yazi/yazi.toml;
          ".icons/default/index.theme".source = ../../home/icons/default/index.theme;
          ".local/share/icons/default/index.theme".source = ../../home/icons/default/index.theme;
          ".config/xdg-desktop-portal-termfilechooser/config".source =
            ../../home/xdg-desktop-portal-termfilechooser/config;

          # symlinks
          ".config/hypr".source = mkSym "${nixDir}/home/hypr";
          ".config/niri".source = mkSym "${nixDir}/home/niri";
          ".config/nvim".source = mkSym "${nixDir}/nvim";
          "scripts".source = mkSym "${nixDir}/scripts";
          ".config/waybar".source = mkSym "${nixDir}/home/waybar";

          # cyberdream themes
          ".config/bat/themes/cyberdream.tmTheme".source = "${thm.textmate}/cyberdream.tmTheme";
          ".config/foot/theme.ini".source = "${thm.foot}/cyberdream.ini";
          ".config/k9s/skins/cyberdream.yaml".source = "${thm.k9s}/cyberdream.yml";
          ".config/kitty/theme.conf".source = "${thm.kitty}/cyberdream.conf";
          ".config/opencode/themes/cyberdream.json".source = "${thm.opencode}/cyberdream.json";
          ".config/posting/themes/cyberdream.yaml".source = "${thm.posting}/cyberdream.yaml";
          ".config/yazi/theme.toml".source = "${thm.yazi}/cyberdream.toml";
          ".local/share/vicinae/themes/cyberdream.toml".source = "${thm.vicinae}/cyberdream.toml";
        };
      };
  };
}
