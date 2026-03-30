{ den, ... }:
{
  den.aspects.zsh = {
    includes = [ (den.provides.user-shell "zsh") ];

    nixos =
      { ... }:
      {
        programs.zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestions.enable = true;
          ohMyZsh = {
            enable = true;
            plugins = [ "git" ];
          };
          shellAliases = {
            cat = "bat";
            cd = "z";
            cdi = "zi";
            eza = "eza --icons auto --git --group-directories-first";
            la = "eza -a";
            ll = "eza -l";
            lla = "eza -la";
            ls = "eza";
            lt = "eza --tree";
            rebuild = "builtin cd $HOME/git/nix && git add -A -N && nh os switch . && builtin cd -";
            s = "kitten ssh";
          };
          interactiveShellInit = ''
            eval "$(zoxide init zsh)"
            eval "$(starship init zsh)"
          '';
        };

        programs.pay-respects.enable = true;

        environment.sessionVariables = {
          EDITOR = "nvim";
          OBSIDIAN_PATH = "$HOME/git/obsidian-vault";
          QT_QPA_PLATFORMTHEME = "gtk3";
          QT_QPA_PLATFORMTHEME_QT5 = "gtk3";
        };
      };
  };
}
