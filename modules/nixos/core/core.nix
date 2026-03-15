{ pkgs, ... }:
{
  # Nix settings
  nix.settings = {
    warn-dirty = false;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://scottmckendry.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "scottmckendry.cachix.org-1:jB2i6xNpH0TiZfTe2p3VfIejB3nUT8bf7PYsn9uOV3I="
    ];
  };

  # Fonts
  fonts = {
    enableDefaultPackages = false;
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        serif = [ "Inter" ];
        sansSerif = [ "Inter" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
    packages = with pkgs; [
      inter
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
    ];
  };

  # Locale
  services.automatic-timezoned.enable = true;
  i18n = {
    defaultLocale = "en_NZ.UTF-8";
    supportedLocales = [
      "en_NZ.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
    ];
  };

  # Common programs
  programs.nix-ld.enable = true;
  programs.zsh.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
