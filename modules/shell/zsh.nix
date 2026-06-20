{ ... }:
{
  den.aspects.zsh = {
    nixos =
      { pkgs, ... }:
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
            rebuild = "~/scripts/rebuild.sh";
            s = "kitten ssh";
          };
          interactiveShellInit = ''
            eval "$(zoxide init zsh)"
            eval "$(starship init zsh)"
          '';
        };

        programs.pay-respects.enable = true;

        environment.sessionVariables = {
          BUN_INSTALL = "$HOME/.local/share/bun";
          DOCKER_CONFIG = "$HOME/.config/docker";
          EDITOR = "nvim";
          GOPATH = "$HOME/.local/share/go";
          KUBECONFIG = "$HOME/.config/kube/config";
          NPM_CONFIG_CACHE = "$HOME/.cache/npm";
          NUGET_PACKAGES = "$HOME/.local/share/nuget";
          OBSIDIAN_PATH = "$HOME/Documents/obsidian";
          QML_IMPORT_PATH = "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml:${pkgs.quickshell}/lib/qt-6/qml";
          QT_QPA_PLATFORMTHEME = "gtk3";
          QT_QPA_PLATFORMTHEME_QT5 = "gtk3";
          TALOSCONFIG = "$HOME/.config/talos/config";
        };
      };
  };
}
