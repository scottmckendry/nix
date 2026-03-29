{
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
  cfg = ./. + "/.config";
  system = pkgs.stdenv.hostPlatform.system;
  vicinaeExts = inputs.vicinae-extensions.packages.${system};
  vicinaeExtNames = [
    "html-symbol-finder"
    "nix"
    "spongebob-text-transformer"
  ];
in
{
  xdg.configFile = {
    "bat/config".source = cfg + "/bat/config";
    "foot/foot.ini".source = cfg + "/foot/foot.ini";
    "git/config".source = cfg + "/git/config";
    "gtk-2.0/gtkrc".source = cfg + "/gtk-2.0/gtkrc";
    "gtk-3.0/settings.ini".source = cfg + "/gtk-3.0/settings.ini";
    "gtk-4.0/settings.ini".source = cfg + "/gtk-4.0/settings.ini";
    "k9s/aliases.yaml".source = cfg + "/k9s/aliases.yaml";
    "k9s/config.yaml".source = cfg + "/k9s/config.yaml";
    "kitty/kitty.conf".source = cfg + "/kitty/kitty.conf";
    "lazygit/config.yml".source = cfg + "/lazygit/config.yml";
    "mako/config".source = cfg + "/mako/config";
    "mimeapps.list".source = cfg + "/mimeapps.list";
    "opencode/opencode.json".source = cfg + "/opencode/opencode.json";
    "opencode/tui.json".source = cfg + "/opencode/tui.json";
    "posting/config.yaml".source = cfg + "/posting/config.yaml";
    "starship.toml".source = cfg + "/starship.toml";
    "vicinae/settings.json".source = cfg + "/vicinae/settings.json";
    "yazi/yazi.toml".source = cfg + "/yazi/yazi.toml";

    # cyberdream themes
    "bat/themes/cyberdream.tmTheme".source = "${inputs.cyberdream.extras.textmate}/cyberdream.tmTheme";
    "foot/theme.ini".source = "${inputs.cyberdream.extras.foot}/cyberdream.ini";
    "k9s/skins/cyberdream.yaml".source = "${inputs.cyberdream.extras.k9s}/cyberdream.yml";
    "kitty/theme.conf".source = "${inputs.cyberdream.extras.kitty}/cyberdream.conf";
    "opencode/themes/cyberdream.json".source = "${inputs.cyberdream.extras.opencode}/cyberdream.json";
    "posting/themes/cyberdream.yaml".source = "${inputs.cyberdream.extras.posting}/cyberdream.yaml";
    "xdg-desktop-portal-termfilechooser/config".source =
      cfg + "/xdg-desktop-portal-termfilechooser/config";
    "yazi/theme.toml".source = "${inputs.cyberdream.extras.yazi}/cyberdream.toml";

    # live symlinks
    "niri".source = mkOutOfStoreSymlink "${nixDir}/home/.config/niri";
    "waybar".source = mkOutOfStoreSymlink "${nixDir}/home/.config/waybar";
    "nvim".source = mkOutOfStoreSymlink "${nixDir}/nvim";

    # hyprlock (monitor substituted per-host in modules/hosts/*.nix)
  };

  home.file = {
    "scripts".source = mkOutOfStoreSymlink "${nixDir}/scripts";
    ".local/share/vicinae/themes/cyberdream.toml".source =
      "${inputs.cyberdream.extras.vicinae}/cyberdream.toml";
  }
  // builtins.listToAttrs (
    map (name: {
      name = ".local/share/vicinae/extensions/${name}";
      value.source = vicinaeExts.${name};
    }) vicinaeExtNames
  );

  # gtk cursor (still needs HM for cursor package install and default/index.theme symlinks)
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };
}
