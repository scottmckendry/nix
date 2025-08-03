{ ... }:
{
  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
      show-failed-attempts = true;

      image = "/tmp/current_wallpaper";
      scaling = "fill";
      color = "16181aff";

      font = "JetBrains Mono Nerd Font";
      font-size = 14;

      indicator-radius = 80;
      indicator-thickness = 8;

      ring-color = "3c4048cc";
      ring-ver-color = "5eff6cff";
      ring-wrong-color = "ff6e5eff";
      ring-clear-color = "bd5effcc";

      inside-color = "16181a88";
      inside-ver-color = "5eff6c88";
      inside-wrong-color = "ff6e5e88";
      inside-clear-color = "bd5eff88";
      inside-caps-lock-color = "ffbd5e88";

      line-color = "5ef1ff88";
      line-ver-color = "5eff6cff";
      line-wrong-color = "ff6e5eff";
      line-clear-color = "bd5effcc";
      line-caps-lock-color = "ffbd5ecc";

      text-color = "ffffffff";
      text-ver-color = "ffffffff";
      text-wrong-color = "ffffffff";
      text-clear-color = "ffffffff";
      text-caps-lock-color = "ffffffff";

      key-hl-color = "5ea1ffff";
      caps-lock-key-hl-color = "ffbd5eff";
      bs-hl-color = "ff5ea0ff";
      caps-lock-bs-hl-color = "f1ff5eff";

      separator-color = "00000000";

      layout-bg-color = "00000000";
      layout-border-color = "5ea1ffcc";
      layout-text-color = "ffffffcc";
    };
  };
}
