{ config, ... }:

let
  nixDir = "${config.home.homeDirectory}/git/nix";
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
      rebuild = "cd ${nixDir} && git add -A -N && nh os switch . && cd -";
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
