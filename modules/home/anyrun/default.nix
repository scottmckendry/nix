{ pkgs, inputs, ... }:

{
  programs.anyrun = {
    enable = true;

    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        rink
        shell
        stdin
      ];

      width.fraction = 0.25;
      y.fraction = 0.25;
      hidePluginInfo = true;
      closeOnClick = true;
    };

    extraCss = builtins.readFile (./. + "/style.css");
    extraConfigFiles = {
      "shell.ron".text = ''
        Config(
          prefix: ":",
        )
      '';
    };
  };
}
