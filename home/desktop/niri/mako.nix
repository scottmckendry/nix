{ ... }:
{
  services.mako = {
    enable = true;
    settings = {
      max-history = 20;
      sort = "-time";
      border-radius = 10;
      border-size = 2;
      font = "Inter 10";
      height = 120;
      margin = 10;
      outer-margin = 20;
      padding = "12,16";
      width = 400;
      icons = 1;
      icon-location = "left";
      markup = 1;
      actions = 1;
      history = 1;
      text-alignment = "left";
      default-timeout = 5000;

      anchor = "top-right";
      layer = "top";

      on-button-left = "invoke-default-action";
      on-button-middle = "dismiss";
      on-button-right = "dismiss-all";
      on-touch = "dismiss";

      # colours:
      background-color = "#16181a";
      border-color = "#5ef1ff";
      progress-color = "over #bd5eff";
    };
  };
}
