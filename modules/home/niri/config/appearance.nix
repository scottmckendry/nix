{ ... }:

{
  programs.niri.settings = {
    layout = {
      gaps = 40;
      background-color = "transparent";
      center-focused-column = "on-overflow";
      always-center-single-column = true;

      default-column-width = {
        proportion = 0.5;
      };
      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];

      tab-indicator = {
        active = {
          color = "#5ef1ff90";
        };
        inactive = {
          color = "#7b849690";
        };
        width = 8;
        gap = 8;
        length.total-proportion = 0.33;
      };

      insert-hint = {
        enable = true;
        display = {
          gradient = {
            from = "#5ef1ff70";
            to = "#bd5eff70";
            angle = 45;
          };
        };
      };

      focus-ring.enable = false;

      shadow = {
        enable = true;
        softness = 30;
        spread = 5;
        offset = {
          x = 0;
          y = 5;
        };
        color = "#0007";
      };
    };

    cursor = {
      theme = "Bibata-Modern-Classic";
      size = 16;
    };
  };
}
