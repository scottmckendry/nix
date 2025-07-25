{
  pkgs,
  config,
  inputs,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in

{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprscrolling.nix
    ./smartgaps.nix
    ../gtk.nix
    ../qt.nix
  ];

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  xdg.configFile."waybar".source = mkOutOfStoreSymlink "${nixDir}/waybar";
  services.dunst.enable = true; # TODO: experiment with mako

  home.packages = with pkgs; [
    bemoji
    bibata-cursors
    blueberry
    cliphist
    hyprshade
    hyprshot
    inotify-tools
    pamixer
    pavucontrol
    playerctl
    udiskie
    waybar
    inter
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "DP-1,3440x1440@144,0x0,1"
        "HDMI-A-1,1920x1080@60,-1080x-400,1,transform,3"
      ];

      cursor = {
        no_hardware_cursors = true;
      };

      exec-once = [
        "hyprlock"
        "udiskie"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "$HOME/.config/waybar/waybar-hot-reload.sh"
      ];

      # keybinds
      "$mainMod" = "SUPER";

      bind =
        let
          anyrunStdin = "anyrun --show-results-immediately true --plugins ${
            inputs.anyrun.packages.${pkgs.system}.stdin
          }/lib/libstdin.so";
        in
        [
          "$mainMod, RETURN, exec, kitty"
          "$mainMod, R, exec, anyrun"
          "$mainMod, E, exec, nautilus"
          "$mainMod, Q, killactive"
          "$mainMod_SHIFT, Q, exit"
          "$mainMod, T, togglefloating"
          "$mainMod_SHIFT, T, fullscreen"
          "$mainMod_SHIFT, L, exec, hyprlock"

          # audio/media
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"

          # move focus
          "$mainMod, J, movefocus, d"
          "$mainMod, K, movefocus, u"
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"

          # workspaces
          "$mainMod, A, workspace, 1"
          "$mainMod, S, workspace, 2"
          "$mainMod, D, workspace, 3"
          "$mainMod, F, workspace, 4"
          "$mainMod, G, workspace, 5"
          "$mainMod_SHIFT, A, movetoworkspace, 1"
          "$mainMod_SHIFT, S, movetoworkspace, 2"
          "$mainMod_SHIFT, D, movetoworkspace, 3"
          "$mainMod_SHIFT, F, movetoworkspace, 4"
          "$mainMod_SHIFT, G, movetoworkspace, 5"

          # misc
          "$mainMod_ALT_SHIFT, S, exec, hyprshot -m region -o ~/Pictures/Screenshots"
          "$mainMod, V, exec, cliphist list | ${anyrunStdin} | cliphist decode | wl-copy" # clipboard history
          "$mainMod, period, exec, BEMOJI_PICKER_CMD='${anyrunStdin}' bemoji" # emoji picker
        ];

      # repeatable keybinds (when held)
      binde = [
        ", XF86AudioRaiseVolume, exec, pamixer -i 2"
        ", XF86AudioLowerVolume, exec, pamixer -d 2"
      ];

      # mousebinds
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # layer rules
      layerrule = [
        "blur, waybar"
        "blur, anyrun"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      decoration = {
        rounding = 10;
        shadow = {
          enabled = true;
          range = 20;
          render_power = 2;
          offset = "0, 10";
          color = "rgba(00000030)";
        };
        blur = {
          enabled = true;
          size = 4;
          passes = 3;
          ignore_opacity = true; # blur where opacity is set via windowrule
          vibrancy = 0.75;
          vibrancy_darkness = 0;
        };
      };

      general = {
        allow_tearing = true;
        gaps_in = 30;
        gaps_out = 60;
        border_size = 2;
        "col.active_border" = "rgba(5ef1ff8a) rgba(bd5eff8a) 135deg";
        "col.inactive_border" = "rgba(00000040)";
      };

      dwindle = {
        smart_split = true;
      };
    };
  };
}
