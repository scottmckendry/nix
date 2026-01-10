{ pkgs, ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      notARepository = "skip";
      gui = {
        nerdFontsVersion = "3";
        border = "rounded";
        mouseEvents = false;
        theme = {
          activeBorderColor = [ "#5ef1ff" ];
          inactiveBorderColor = [ "#7b8496" ];
          searchingActiveBorderColor = [ "#ff5ef1ff" ];
          optionsTextColor = [ "#3c4048" ];
          selectedLineBgColor = [ "#3c4048" ];
          cherryPickedCommitBgColor = [ "#3c4048" ];
          cherryPickedCommitFgColor = [ "#ff5ea0" ];
          unstagedChangesColor = [ "#ffbd5e" ];
          defaultFgColor = [ "#ffffff" ];
        };
      };
      git = {
        parseEmoji = true;
        pagers = [
          {
            colorArg = "always";
            pager = "delta --paging=never";
          }
        ];
      };
    };
  };
}
