{ config, ... }:

let
  nixDir = "${config.home.homeDirectory}/git/nix";
  rebuildCmd = ''
    builtin cd ${nixDir} && git add -A -N
    if [ -f /etc/NIXOS ]; then
      sudo nixos-rebuild switch --flake .
    else
      nix run home-manager/master -- switch --flake .#default -b backup
    fi
    builtin cd -
  '';
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
    shellAliases = {
      cd = "z";
      cdi = "zi";
      cat = "bat";
      rebuild = rebuildCmd;
      s = "kitten ssh";
      ff = "fastfetch --logo ${nixDir}/fastfetch/logos/ascii.txt";
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true;
  };
}
