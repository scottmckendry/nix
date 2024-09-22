{ pkgs, config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixDir = "${config.home.homeDirectory}/git/nix";
in
{
  xdg.configFile."waybar".source = mkOutOfStoreSymlink "${nixDir}/waybar";

  services.dunst.enable = true;
  programs.wofi.enable = true;

  programs.hyprlock = {
    enable = true;
    settings = {
      hide_cursor = true;
      grace = 0;
      background = {
        monitor = "";
        path = "$HOME/git/nix/wallpapers/grass.png";
        blur_passes = 2;
      };
      input-field = {
        monitor = "DP-2";
        size = "250, 60";
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.2)";
        font_color = "rgba(200, 200, 200, 1)";
      };
      # clock
      label = {
        monitor = "DP-2";
        text = "cmd[update:1000] echo -n $(date +'%-I:%M %p')";
        size = "250, 60";
        color = "rgba(200, 200, 200, 1)";
        font_size = 45;
        font_family = "JetBrains Mono";
        position = "0, 100";
        halign = "center";
        valign = "center";
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        # lock after 5 minutes
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
        # turn off monitor/s shortly after locking
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        # suspend after 20 minutes
        {
          timeout = 1200;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    blueman
    cliphist
    grim
    inotify-tools
    pamixer
    pavucontrol
    playerctl
    slurp
    swappy
    waybar
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "DP-2,3440x1440@144,0x0,1"
        "HDMI-A-2,1920x1080@60,-1080x-400,1,transform,3"
      ];

      exec-once = [
        "hypridle"
        "hyprlock"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "$HOME/.config/waybar/waybar-hot-reload.sh"
        "blueman-applet"
      ];

      # keybinds
      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, RETURN, exec, alacritty"
        "$mainMod, R, exec, wofi --show drun"
        "$mainMod, Q, killactive"
        "$mainMod_SHIFT, Q, exit"
        "$mainMod, T, togglefloating"
        "$mainMod_SHIFT, T, fullscreen"
        "$mainMod_SHIFT, L, exec, hyprlock"

        # audio/media
        ", XF86AudioRaiseVolume, exec, pamixer -i 2"
        ", XF86AudioLowerVolume, exec, pamixer -d 2"
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

        # screenshot & pipe to swappy
        "$mainMod_ALT_SHIFT, S, exec, grim -g \"$(slurp)\" - | swappy -f -"

        # clipboard
        "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
      ];

      # mousebinds
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # window rules
      windowrule = [
        # "float,.*"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 4;
          passes = 3;
        };
        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
      };

      general = {
        gaps_in = 10;
        gaps_out = 20;
        border_size = 2;
      };
    };
  };
}
